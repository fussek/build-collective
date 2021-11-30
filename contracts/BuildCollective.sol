pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

import "./Ownable.sol";

/*
1. Open user account, with a name and a balance.
2. Open an entreprise account, with a name, an owner and some members, possibly with a balance.
3. Create projects on which we can give money for sponsoring. Each project has a balance, a name and a list of contributors.
Each project belongs to a user or an entreprise. The money given to the project can be send to contributors, and contributors only.
4. On a project, you should be able to create bounties. Bounties are bugs with a reward: if you spot a bug and you want to have it fix quickly, open a bounty and put some eth on it.
When the fix is pushed, the author will get the eth. He’s a bounty hunter.
5. Add the ability to put some link to commits from GitHub or GitLab in the projects, to keep a track of what has been done.
*/

contract BuildCollective is Ownable {
  struct User {
    string username;
    uint256 balance;
    bool registered;
  }

  // Enterprise
  struct EnterpriseAccount {
    string name;
    uint256 balance;
    //User[] members;
  }

  // Project
  struct Project {
    User owner;
    EnterpriseAccount enterpriseOwner;
    uint256 balance;
    string link;
    string name;
  }

  // Bounty
  struct Bounty {
    string link;
    int256 reward;
    bool active;
  }

  EnterpriseAccount[] private enterprises;
  Project[] public projects;
  Bounty[] public bounties;

  mapping(address => User) private users;
  mapping(address => uint[]) private userToEnterprises;
  mapping(uint => address[]) private projectsToContributors;
  mapping(uint => uint) private bountyToProject;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event EnterpriseCreated(User indexed owner);
  event ProjectCreated(string name);
  event BountyCreated();

  function getUser(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function getEnterprise(uint _enterpriseId) public view returns (EnterpriseAccount memory) {
    return enterprises[_enterpriseId];
  }

  function getUserEnterpriseIds() public view returns (uint[] memory) {
    require(users[msg.sender].registered);
    return userToEnterprises[msg.sender];
  }

  function getProjects() public view returns (Project[] memory) {
    return projects;
  }

  function signUp(string memory username) public returns (User memory) {
    require(bytes(username).length > 0);
    users[msg.sender] = User(username, 0, true);
    emit UserSignedUp(msg.sender, users[msg.sender]);
  }

  function addBalance(uint256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance += amount;
    return true;
  }

  // NEW functions
  function createEnterpriseAccount(string memory name, uint balance) public {
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    uint enterprise_id = enterprises.push(EnterpriseAccount(name, balance)) - 1;
    userToEnterprises[msg.sender].push(enterprise_id);
    emit EnterpriseCreated(users[msg.sender]);
  }

  function createProject(string memory name, uint _enterpriseId, uint balance) public {
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    EnterpriseAccount memory enterprise;
    if (_enterpriseId < 0) {
      enterprise = enterprises[_enterpriseId];
    }
    projects.push(Project(users[msg.sender], enterprise, balance, "", name));
    emit ProjectCreated(name);
  }

  function openBounty(string memory link, int256 reward, uint _projectId) public {
    require(users[msg.sender].registered);
    uint bounty_id = bounties.push(Bounty(link, reward, true)) - 1;
    bountyToProject[bounty_id] = _projectId;
    emit BountyCreated();
  }

  function closeBounty(uint _bountyId, address _hunterAddress) public returns (bool) {
    require(users[msg.sender].registered);
    bounties[_bountyId].active = false;
    projects[bountyToProject[_bountyId]].balance -= uint(bounties[_bountyId].reward);
    users[_hunterAddress].balance += uint(bounties[_bountyId].reward);
    return true;
  }

  function supportProject(uint _projectId, int256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    users[msg.sender].balance -= uint(amount);
    projects[_projectId].balance += uint(amount);
    projectsToContributors[_projectId].push(msg.sender);
    return true;
  }

  function addLink(uint _projectId, string memory link) public returns (bool) {
    require(users[msg.sender].registered);
    projects[_projectId].link = link;
    return true;
    }
}