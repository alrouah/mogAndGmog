import type { HardhatUserConfig } from "hardhat/config";

import "@matterlabs/hardhat-zksync-deploy";
import "@matterlabs/hardhat-zksync-solc";

import "@matterlabs/hardhat-zksync-verify";

// dynamically changes endpoints for local tests
// export const zkSyncTestnet = {
//   url: "https://sepolia.era.zksync.dev",
//   ethNetwork: "sepolia",
//   zksync: true,
//   verifyURL: "https://explorer.sepolia.era.zksync.dev/contract_verification",
// };

export const zkSyncTestnet = {
  url: "https://mainnet.era.zksync.io",
  ethNetwork: "mainnet",
  zksync: true,
  verifyURL: "https://zksync2-mainnet-explorer.zksync.io/contract_verification",
};

const config: HardhatUserConfig = {
  zksolc: {
    version: "1.5.6", // ensure the correct version
    compilerSource: "binary",
    settings: {
      optimizer: {
        enabled: true, // or false, if not used during deployment
        runs: 200, // make sure this matches the deployment setting
      },
    },
  },

  defaultNetwork: "zkSyncTestnet",
  networks: {
    hardhat: {
      zksync: true,
    },
    zkSyncTestnet,
  },
  solidity: {
    version: "0.8.25",
  },
};

export default config;
