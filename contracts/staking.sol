pragma solidity ^0.8.1;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ASTStaking is ReentrancyGuard, Ownable {
  IERC20 public AS;
  IERC20 public AST;
  mapping(address => uint256) timeStaked;
  event Staked(address indexed staker, uint256 amount, uint256 timeStaked);
  event Withdrawal(address owner, uint256 amount);
  bool open;

  modifier onlyOpen() {
    require(open, "Contract not open");
    _;
  }
constructor() {
    AST = IERC20(0x6B6433Fca6e7414A98b03F7001f36f89201FE669);
    AS = IERC20(0xbB6fa3C4e304BeeAA81e530565d6B24dCbecAff0);
    open = true;
  }


  function stake(uint256 _amountToStake) external nonReentrant onlyOpen {
    require(_amountToStake > 0, "Stake: must be greater than 0");
    require(
      AST.allowance(msg.sender, address(this)) > _amountToStake,
      "Stake: Allowance not enough"
    );
    require(AST.transferFrom(msg.sender, address(this), _amountToStake));
    require(AS.transfer(msg.sender, _amountToStake));
    timeStaked[msg.sender] = block.timestamp;

    emit Staked(msg.sender, _amountToStake, block.timestamp);
  }

  function withdraw(uint256 _amountToWithdraw) external nonReentrant onlyOpen {
    require(_amountToWithdraw > 0, "Withdraw: Amount should be greater than 0");

    require(
      ((block.timestamp - timeStaked[msg.sender]) / 86400) >= 2,
      "Must have staked for 2days or more"
    );
    require(
      AST.allowance(msg.sender, address(this)) > _amountToWithdraw,
      "Stake: Allowance not enough"
    );
    require(AS.transferFrom(msg.sender, address(this), _amountToWithdraw));
    uint256 bonus = ((((block.timestamp - timeStaked[msg.sender]) / 86400) *
      10**3) / 365) * _amountToWithdraw;
    uint256 total = _amountToWithdraw + (bonus / 10**3);

    require(AST.balanceOf(address(this)) > total, "Contract not Funded");
    require(AST.transfer(msg.sender, total));
    emit Withdrawal(msg.sender, total);
  }

  function freezeStaking() public onlyOwner {
    open = false;
  }

  function openStaking() public onlyOwner {
    open = true;
  }
}
