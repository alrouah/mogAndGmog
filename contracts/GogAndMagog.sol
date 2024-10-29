// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title GogAndMagog
 * @dev An ERC20 token contract with restrictions on transfers during the first 20 minutes after liquidity is added.
 * Only 1% of the total supply can be transferred during this period, and trading is restricted for a few "dead blocks"
 * after liquidity is added to prevent frontrunning.
 */
contract GogAndMagog is ERC20, Ownable {
  // Number of blocks during which trading is restricted
  uint256 public constant DEAD_BLOCKS = 3;

  // Maximum 1% of total supply can be transferred during restriction period
  uint256 public constant MAX_TRANSFER_PERCENTAGE = 1 ether;

  // Timestamp when liquidity is added
  uint256 public protectionActivateTime;

  // Duration of the transfer restriction after liquidity addition
  uint256 public constant RESTRICTION_DURATION = 20 minutes;

  // Maximum supply of tokens
  uint256 public constant MAX_SUPPLY = 99000000 * 10 ** 18;

  // Cumulative amount of tokens transferred during the restriction period
  uint256 public totalTransferredDuringRestriction;

  // Track the last transfer block for each address to enforce dead block restrictions
  mapping(address => uint256) public lastTransferBlock;

  // Flag to indicate if liquidity has been added
  bool public isProtectionActivated = false;

  // Event to signal the activation of sniper protection, including the time of activation
  event ActivateSniperProtection(bool isProtection, uint256 protectionTime);

  /**
   * @dev Constructor that mints the total supply to the admin address.
   * @param admin Address that receives the initial token supply and owns the contract.
   */
  constructor(address admin) ERC20("GogAndMagog", "MAGOG") Ownable(admin) {
    // Mint the maximum supply to the admin
    _mint(admin, MAX_SUPPLY);
  }

  /**
   * @dev Activates sniper protection to prevent bots from exploiting early liquidity.
   */
  function activateSniperProtection() external onlyOwner {
    // Ensure this function is only called once by checking if protection has already been activated
    require(!isProtectionActivated, "Sniper protection already activated");

    // Set the flag to true, indicating sniper protection is active
    isProtectionActivated = true;

    // Record the current timestamp when protection is activated
    protectionActivateTime = block.timestamp;

    // Emit an event to notify that sniper protection has been activated and the activation time
    emit ActivateSniperProtection(isProtectionActivated, protectionActivateTime);
  }

  /**
   * @dev Internal function to check whether a transfer is allowed based on liquidity and time restrictions.
   * It ensures that:
   * 1. Transfers during the dead blocks are disallowed.
   * 2. The total transfer amount in the first 20 minutes doesn't exceed 1% of the total supply.
   *
   * @param from Address of the sender.
   * @param to Address of the receiver.
   * @param value Amount of tokens being transferred.
   */
  function _isTradingAllowed(address from, address to, uint256 value) internal {
    // Check if liquidity has been added
    if (isProtectionActivated) {
      // Ensure transfers do not occur during the restricted "dead blocks"
      require(block.number > lastTransferBlock[msg.sender] + DEAD_BLOCKS, "Trading restricted during dead blocks");

      // Restrict transfers during the first 20 minutes (restriction period)
      if (block.timestamp < protectionActivateTime + RESTRICTION_DURATION) {
        // 1% of total supply
        uint256 maxTransferAmount = (MAX_SUPPLY * MAX_TRANSFER_PERCENTAGE) / 100 ether;

        // Calculate remaining transferable amount during restriction period
        uint256 remainingLimit = maxTransferAmount - totalTransferredDuringRestriction;

        // Ensure the transfer value does not exceed the remaining limit
        require(value <= remainingLimit, "Transfer exceeds remaining 1% limit during restriction period");

        // Update the total transferred amount during the restriction period
        totalTransferredDuringRestriction += value;
      }
    }
    // Call the parent contract's _update method to process the transfer
    super._update(from, to, value);

    // Update the last transfer block for the sender to enforce the dead block restriction
    lastTransferBlock[msg.sender] = block.number;
  }

  /**
   * @dev Override the _update function from the ERC20 contract to include the trading restriction checks.
   * This function is called during any token transfer and ensures that trading restrictions are respected.
   *
   * @param from Address of the sender.
   * @param to Address of the receiver.
   * @param value Amount of tokens being transferred.
   */
  function _update(address from, address to, uint256 value) internal override {
    // Check trading restrictions before processing the transfer
    _isTradingAllowed(from, to, value);
  }
}