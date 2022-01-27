pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract AST is ERC20 {
  constructor() ERC20("AST", "ASt") {
    _mint(msg.sender, 1000000000e18); //1000 tokens totalsupply
  }
}
