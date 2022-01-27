pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AS is ERC20 {
  constructor() ERC20("AS", "AS") {
    _mint(msg.sender, 1000000e18); //1000000 tokens totalsupply
  }
}
