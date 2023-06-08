# Dapp Boilerplate

This is a Dapp boilerplate built using React and Hardhat. It allows you to generate contract state when the connect wallet button is clicked. It also uses the Rainbow kit for the connect wallet component. 

## Getting Started

To get started with the Dapp boilerplate, follow these steps:

1. Install Vite by running the following command:
   ```
   npm create vite@latest react-app -- --template react
   ```
2. Navigate to the react-app directory and install dependencies:
   ```
   cd react-app
   npm install
   ```
3. Install Hardhat:
   ```
   npm install --save-dev hardhat
   npx hardhat
   ```
4. Install dotenv:
   ```
   npm i dotenv
   ```
5. Create a `.env` file with the following contents:
   ```
   SEPOLIA_PRIVATE_KEY = ""
   ALCHEMY_SEPOLIA_API_KEY =""
   OWNER_ADDRESS = ""
   CONTRACT_ADDRESS = ""
   ETHERSCAN_API_KEY = ""
   ```
   Replace the empty strings with the relevant values.
6. Deploy the contract:
   ```
   npx hardhat run --network sepolia scripts/deploy.js
   ```
7. Verify the contract:
   ```
   npx hardhat verify --network sepolia <address>
   ```
   Replace `<address>` with the contract address.
8. Install Rainbow kit for the connect wallet component:
   ```
   npm init @rainbow-me/rainbowkit@latest
   ```
9. Run the server:
   ```
   npm run dev
   ```

## Contributing

If you have any suggestions or find any bugs, feel free to open an issue or submit a pull request.
