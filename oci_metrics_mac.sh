#!/bin/bash
compartments=$(oci iam compartment list --access-level any --compartment-id-in-subtree true --query "data[*].id" --raw-output)
echo "COMPARTMENT NAME, INSTANCE ID, CPU Utilization, Memory Uitlization"
# Obtendo a data atual em formato Unix timestamp
current_time=$(date +%s)

# Calculando o Unix timestamp de 30 dias atrás
start_time=$((current_time - 30*24*60*60))

# Convertendo os Unix timestamps para o formato desejado
start_time_formatted=$(date -u -r $start_time +'%Y-%m-%dT%H:%M:%SZ')
end_time_formatted=$(date -u -r $current_time +'%Y-%m-%dT%H:%M:%SZ')

for compartment_id in $compartments; do
    compartment_id=$(echo "$compartment_id" | sed 's/,//g' | sed 's/"//g')
    compartment_name=$(oci iam compartment get --compartment-id $compartment_id --query 'data."name"' --raw-output) 
    instances=$(oci compute instance list --compartment-id $compartment_id --query "data[*].id" --raw-output)
    if [ -n "$instances" ]; then
        instances=$(echo "$instances" | tr -d '[],"')
        for instance_id in $instances; do
        instance_id=$(echo "$instance_id" | sed 's/,//g')
        # Executar o comando e armazenar a saída JSON em uma variável
        command_output_memory=$(oci monitoring metric-data summarize-metrics-data --compartment-id $compartment_id --namespace oci_computeagent --query-text "MemoryUtilization[1d]{resourceId=$instance_id}.max()" --start-time $start_time_formatted --end-time $end_time_formatted)
        command_output_cpu=$(oci monitoring metric-data summarize-metrics-data --compartment-id $compartment_id --namespace oci_computeagent --query-text "CpuUtilization[1d]{resourceId=$instance_id}.max()" --start-time $start_time_formatted --end-time $end_time_formatted)
        if [ "$instance_id" != "[" ] && [ "$instance_id" != "]" ]; then
        # Extrair todos os valores "value" do JSON e calcular a média
            average_memory=0
            count_memory=0
            total_memory=0
            values=$(echo "$command_output_memory" | jq -r '.data[0]."aggregated-datapoints"[] | .value')
            if [ -n "$values" ]; then
                while IFS= read -r value; do
                total_memory=$(echo "$total_memory + $value" | bc)
                count_memory=$((count_memory + 1))
                done <<< "$values"
            fi

            if [ $count_memory -gt 0 ]; then
                average_memory=$(echo "scale=2; $total_memory / $count_memory" | bc)
            fi

            average_cpu=0
            count_cpu=0
            total_cpu=0

            values=$(echo "$command_output_cpu" | jq -r '.data[0]."aggregated-datapoints"[] | .value')
            if [ -n "$values" ]; then
                while IFS= read -r value; do
                total_cpu=$(echo "$total_cpu + $value" | bc)
                count_cpu=$((count_cpu + 1))
                done <<< "$values"
            fi
            if [ $count_cpu -gt 0 ]; then
                average_cpu=$(echo "scale=2; $total_cpu / $count_cpu" | bc)
            fi
            echo "$compartment_name, $instance_id, $average_cpu, $average_memory"
            
        fi
        done
    fi    
done