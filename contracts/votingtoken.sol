// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract votingToken is ERC20{

event poolId(uint32 _voteId, string message);

constructor(uint256 amount, string memory _name, string memory _symbol) ERC20( _name, _symbol){
    admin = msg.sender;
    _mint(address(this), amount * (10**decimals()));
/////////////// /////////////////////////////////////////////
}

address admin;
address[] contendersContainer;
uint[] public vottingPools;
uint[] results;
uint price = 300 gwei;
uint public voteprice = 50;
uint public PoolCreationPrice = 200;
uint voteId = 10010;
mapping (address => userResult) voteCount;
mapping (uint => address[]) contendersList;
mapping (uint => mapping(address => uint)) pointCount;
mapping (uint => bool) voteStatus;
mapping (uint => address) votingAdmin;
mapping (address => mapping(uint => bool)) voteCheck;

struct userResult {
    address _address;
    uint _totalPoints;
}


function withdraw(uint _amount) public _onlyadmin(msg.sender) {
    payable(msg.sender).transfer(_amount * 1000000000000000000);
}


function PurchaseToken() payable public {
  uint purchase=  msg.value / price;
 _transfer((address(this)), (msg.sender), purchase);
}


function createVotePool2(address _contender1, address _contender2, address _contender3) noRepeat( _contender1, _contender2, _contender3) public returns (uint yourVoteId){
   require(balanceOf(msg.sender) >= PoolCreationPrice, "INSUFFICIENT FUND, BUY OUR TOKEN");
   transfer(address(this), PoolCreationPrice);
   vottingPools.push(voteId);
    voteStatus[voteId] = true;
    contendersContainer.push(_contender1);
    contendersContainer.push(_contender2);
    contendersContainer.push(_contender3);
    contendersList[voteId] = contendersContainer;
    contendersContainer.pop();
    contendersContainer.pop();
    contendersContainer.pop();
    votingAdmin[voteId] = msg.sender;
    yourVoteId = voteId;
    emit poolId (uint32(voteId), "is your vote Id");
    voteId++;
}

function DisplayContenders(uint _voteId) view public returns(address[] memory contenders) {
contenders = contendersList[_voteId];
}


function DisplayOwner(uint _voteId) public view returns(address owner) {
    owner = votingAdmin[_voteId];
}

function DisplayTotalVotes(uint _voteId) public view returns (uint TotalPoints){
   address[] memory _contendersList = contendersList[_voteId];
   address contender1 = _contendersList[0];
   address contender2 = _contendersList[1];
   address contender3 = _contendersList[2];
    TotalPoints = pointCount[_voteId][contender1] + pointCount[_voteId][contender2] + pointCount[_voteId][contender3];
}

function Vote(uint _voteId, address _contender1, address _contender2, address _contender3) noRepeat( _contender1, _contender2, _contender3) public { //norepeat
    require(balanceOf(msg.sender) >= voteprice, "INSUFFICIENT FUND, BUY OUR TOKEN");
   transfer(address(this), voteprice);

    require (voteStatus[_voteId], "Voting closed");
    bool status = voteCheck[msg.sender][_voteId];
    require(!status, "Already Voted");
    pointAssigner(_voteId, _contender1, _contender2, _contender3);
    uint voteIdN = _voteId;
    voteCheck[msg.sender][voteIdN] = true;
}

function pointAssigner(uint _voteId, address _contender1, address _contender2, address _contender3) private {
    pointCount[_voteId][_contender1] += 3;
    pointCount[_voteId][_contender2] += 2;
    pointCount[_voteId][_contender3] += 1;
}

function closeVotingPool(uint _voteId) public {
    voteStatus[_voteId] = false;
}

function DisplayWinner(uint _voteId) public view returns (address winner) {
    bool status = voteStatus[_voteId];
    require(!status, "VOTTING NOT OVER YET");
   address[] memory _contendersList = contendersList[_voteId];
   uint contender1 = pointCount[_voteId][_contendersList[0]];
   uint contender2 = pointCount[_voteId][_contendersList[1]];
   uint contender3 = pointCount[_voteId][_contendersList[2]];

   if (contender1 > contender2 && contender1 > contender3) {
       winner = _contendersList[0];
   } else if (contender2 > contender3){
       winner = _contendersList[1];
   } else {
       winner = _contendersList[2];
       }
}

receive() external payable{
    
}
fallback() external payable{}


modifier noRepeat(address _contenders1, address _contenders2, address _contenders3) {
    require (_contenders1 != _contenders2, "ADDRESS 1 AND 2 ARE THE SAME");
    require (_contenders1 != _contenders3, "ADDRESS 1 AND 3 ARE THE SAME");
    require (_contenders2 != _contenders3, "ADDRESS 2 AND 3 ARE THE SAME");
    _;
}

modifier _onlyadmin(address _address){
    require(_address == admin, "Not Admin");
    _;
}
}

