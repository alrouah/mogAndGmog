# GogAndMagog ERC20 Token Smart Contract

## Overview

The **GogAndMagog** contract is an ERC20 token implementation that introduces mechanisms to prevent front-running attacks and protect against exploitative trading behavior during the early stages of liquidity addition. This contract restricts token transfers for the first 20 minutes after liquidity is added and limits the total transferable amount during this period to 1% of the total supply.

## Features

- **ERC20 Standard**: Fully compliant with the ERC20 token standard, allowing for seamless integration with wallets and other decentralized applications.
- **Sniper Protection**: Prevents bots and malicious actors from exploiting early liquidity by restricting transfers during the initial period after liquidity is added.
- **Transfer Restrictions**: Limits the total amount of tokens that can be transferred during the first 20 minutes to 1% of the total supply.
- **Dead Blocks**: Implements a mechanism to prevent trading during a specified number of blocks after a transfer has occurred, adding an additional layer of protection.

## Contract Details

### Basic Information

- **Token Name**: GogAndMagog
- **Token Symbol**: MAGOG
- **Maximum Supply**: 99,000,000 MAGOG (99 million)
- **Owner**: The address that deploys the contract will be the initial owner and receive the entire supply.

### Key Variables

- `DEAD_BLOCKS`: Number of blocks during which trading is restricted (set to 3).
- `MAX_TRANSFER_PERCENTAGE`: Maximum percentage of the total supply that can be transferred during the restriction period (set to 1%).
- `protectionActivateTime`: Timestamp when liquidity is added and protection is activated.
- `RESTRICTION_DURATION`: Duration of the transfer restriction after liquidity addition (set to 20 minutes).
- `totalTransferredDuringRestriction`: Cumulative amount of tokens transferred during the restriction period.
- `lastTransferBlock`: Mapping to track the last transfer block for each address.
- `isProtectionActivated`: Boolean flag to indicate if sniper protection has been activated.

### Events

- `ActivateSniperProtection`: Emitted when sniper protection is activated, including the activation time.

### Functions

- **Constructor**: 
  - Initializes the token with the maximum supply and mints it to the owner's address.
  
- **activateSniperProtection**: 
  - Activates sniper protection, marking the timestamp when protection begins. Can only be called by the contract owner.
  
- **_isTradingAllowed**: 
  - Internal function that checks whether a transfer is allowed based on the restrictions defined. Ensures that transfers during the dead blocks are disallowed and that the total transfer amount during the restriction period does not exceed the allowed limit.
  
- **_update**: 
  - Overrides the internal `_update` function from the ERC20 contract to include trading restriction checks before processing any token transfers.

## Usage

1. **Deploy the Contract**: The contract must be deployed on the Ethereum blockchain by providing the owner's address in the constructor.
2. **Activate Sniper Protection**: After adding liquidity, the owner must call `activateSniperProtection()` to activate the transfer restrictions.
3. **Transfer Tokens**: Users can transfer tokens following the defined rules and restrictions. The `_update` function ensures that the trading restrictions are enforced.

## Security Considerations

- The contract incorporates mechanisms to prevent front-running and exploitative trading behavior, which enhances the security of the token during its early stages.
- It is essential for the owner to activate sniper protection promptly after liquidity is added to ensure the protection mechanisms are in effect.

## Conclusion

The **GogAndMagog** ERC20 token contract provides a robust framework for launching a token while protecting against malicious trading behavior. Its implementation of sniper protection and transfer restrictions helps maintain fairness during critical early trading phases. 

For more information, feel free to check the code or contact the developer for any inquiries related to the token or its features.