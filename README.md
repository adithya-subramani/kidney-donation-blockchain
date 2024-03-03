# Local Blockchain Network for Kidney Donation and Transplantation Chain

## Overview

This project establishes a local blockchain network dedicated to managing kidney donation and transplantation processes. Leveraging the power of blockchain, the system ensures transparency, security, and traceability in every step of the donation journey.

## Requirements:

### Ganache:

[Ganache](https://www.trufflesuite.com/ganache) is a personal blockchain for Ethereum development that you can use to deploy contracts, develop your dApps, and run your tests. It provides a convenient and feature-rich environment for local blockchain testing.

#### Installation:

- Download Ganache from [official website](https://www.trufflesuite.com/ganache).
- Follow the installation instructions for your operating system.

### Truffle:

[Truffle](https://www.trufflesuite.com/truffle) is a popular development framework for Ethereum that simplifies the process of building, testing, and deploying smart contracts.

#### Installation:

- Install Truffle globally using npm:

  ```bash
  npm install -g truffle
  ```

### Python and npm:

This project relies on [Python](https://python.org/) to run scripts.

## Getting Started

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/adithya-subramani/kidney-donation-blockchain.git
   cd kidney-donation-blockchain
   ```

2. **Install Dependencies:**

   ```bash
   pip install -r requirements.txt
   ```

3. **Start Ganache:**

   Run Ganache and create a new workspace. Configure Truffle to connect to your local Ganache instance.

4. **Compile and Deploy Smart Contracts:**

   ```bash
   truffle compile
   truffle migrate
   ```

5. **Run the Application:**

   ```bash
   python app.py
   ```

   Open your browser and go to `http://127.0.0.1:5000` to access the application.

## Features

- **Patient Management:**
  - Register patients with relevant information.
  - Track patient organ compatibility.

- **Donor Management:**
  - Enlist donors willing to contribute.
  - Record donor details and organ availability.

- **Transplantation Match:**
  - Algorithm to match donors with compatible patients.
  - Real-time updating of transplantation pairs.

- **Pledge Verification:**
  - Verify and manage pledges from donors.

