<h3 align="center">OCI Metrics Aggregator</h3>

<div align="center">

[![Status](https://img.shields.io/badge/status-active-success.svg)]()
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](/LICENSE)

</div>

---

<p align="center"> This script gathers CPU and Memory utilization metrics from Oracle Cloud Infrastructure (OCI) instances and outputs the results to a CSV file for further analysis.
    <br> 
</p>

## 📝 Table of Contents

- [About](#about)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Output](#output)
- [Contributing](../CONTRIBUTING.md)
- [Authors](#authors)

## 🧐 About <a name="about"></a>

This script is designed to gather CPU and Memory utilization metrics from OCI instances using the OCI Command Line Interface (CLI). It calculates the average CPU and Memory utilization for each instance over the past 30 days and outputs the results in CSV format.

## 🛠️ Prerequisites <a name="prerequisites"></a>

Before using this script, make sure you have the OCI CLI installed and properly configured with the necessary credentials. You can follow the [OCI CLI documentation](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/cliconcepts.htm) for installation and setup instructions.

## 🚀 Usage <a name="usage"></a>

1. Clone this repository to your local machine.
2. Open a terminal and navigate to the repository's directory.
3. Make sure the `oci_metrics.sh` script has executable permissions. If not, you can use the command: `chmod +x oci_metrics.sh`.
4. Run the script using the command: `bash oci_metrics.sh > metrics.csv`.

The script will gather CPU and Memory utilization metrics for each instance across all compartments you have access to and output the results to the `metrics.csv` file.

## 📄 Output <a name="output"></a>

The output CSV file will have the following format:

INSTANCE ID, CPU Utilization, Memory Utilization


You can use this CSV file for further analysis and reporting.

## ✍️ Authors <a name="authors"></a>

- Matheus Basilio Cintra - [@MatheusBasilio](https://github.com/MatheusBasilio)

