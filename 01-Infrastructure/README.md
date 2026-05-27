# 📂 Step 01: Initialization, Active Directory, DNS and DHCP 

This directory contains the first phase of the infrastructure Lab automation under **Windows Server 2025**. The objective of this step is to transform a blank, freshly installed server into a fully operational Domain Controller, validated by a Windows 11 client machine.

---

## 🛠️ Lab Architecture

* **Hypervisor:** VMware Workstation
* **Network:** Dedicated (NAT Mode) - Subnet: `192.168.80.0/24`
* **Server (DC):** Windows Server 2025 (`SRV-ADDS-01` | IP: `192.168.80.10`)
* **Client:** Windows 11 Pro (joined to the domain via DHCP)

---

## 📜 PowerShell Scripts Breakdown

The configuration process has been segmented into 3 distinct scripts to accommodate the deployment workflow and manage required system reboots.

### 1️⃣ `01-Setup-WindowsServer.ps1` : Network & System Initialization
This script prepares the bare-metal OS to host core infrastructure roles.
* Renames the computer to `SRV-ADDS-01`.
* Renames the active network adapter interface to `LAN`.
* Aligns the network configuration: switches the interface from DHCP to a **Static IP address** (`192.168.80.10/24`) and sets the VMware default gateway (`192.168.80.2`).
* Configures the primary DNS server to the local loopback address (`127.0.0.1`), a mandatory prerequisite for Active Directory.
* Triggers a forced system reboot to apply the hostname change.

### 2️⃣ `01-Install-Features.ps1` : Infrastructure Roles Deployment
This script installs the software blocks required for the Lab environment.
* Implements a dynamic loop (`foreach`) combined with robust error handling blocks (`try/catch`).
* Installs the following core roles simultaneously along with their respective management tools (RSAT):
  * **AD-Domain-Services** (Active Directory)
  * **DNS** (Name Resolution)
  * **DHCP** (Dynamic IP Allocation)

### 3️⃣ `03-Initialize-AD.ps1` : Active Directory Forest Promotion
This script configures and finalizes the creation of the identity management infrastructure.
* Deploys a brand new root forest.
* **Clean Code Best Practices:** Leverages the **Splatting** technique (via the `@ForestConfig` hashtable) to ensure script readability, clean layout, and easy maintenance.
* **Security:** Utilizes the native interactive system prompt to securely capture the DSRM (Safe Mode) password.

---

## 🏁 Client Validation Phase

To validate the integrity and proper execution of the automation pipeline:
1. A **Windows 11 Pro** virtual machine was connected to the same virtual network.
2. The DHCP server successfully allocated a dynamic IP configuration within the defined scope.
3. The client machine was successfully joined to the domain.

---

## 🚀 How to Use These Scripts

1. Clone this repository or transfer the scripts to your freshly installed Windows Server 2025 machine.
2. Open a **PowerShell console as an Administrator**.
3. Execute the scripts in numerical order.