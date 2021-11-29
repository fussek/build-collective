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
    User owner;
    uint256 balance;
    //User[] members;
  }

  // Project
  struct Project {
    User owner;
    EnterpriseAccount enterpriseOwner;
    //User[] contributors;
    int256 reward;
    string link;
    string name;
  }

  EnterpriseAccount[] public enterprises;
  Project[] public projects;

  mapping(address => User) private users;

  event UserSignedUp(address indexed userAddress, User indexed user);
  event EnterpriseCreated(User indexed owner);
  event ProjectCreated(string name);

  function getUser(address userAddress) public view returns (User memory) {
    return users[userAddress];
  }

  function getEnterprise(uint _enterpriseId) public view returns (EnterpriseAccount memory) {
    return enterprises[_enterpriseId];
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
  function createEnterpriseAccount(string memory name) public {
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    enterprises.push(EnterpriseAccount(name, users[msg.sender], 0));
    emit EnterpriseCreated(users[msg.sender]);
  }

  function createProject(string memory name, uint _enterpriseId) public {
    require(users[msg.sender].registered);
    require(bytes(name).length > 0);
    EnterpriseAccount memory enterprise;
    if (_enterpriseId < 0) {
      enterprise = enterprises[_enterpriseId];
    }
    projects.push(Project(users[msg.sender], enterprise, 0, "", name));
    emit ProjectCreated(name);
  }

  function supportProject(uint _projectId, int256 amount) public returns (bool) {
    require(users[msg.sender].registered);
    projects[_projectId].reward += amount;
    return true;
  }

  function addLink(uint _projectId, string memory link) public returns (bool) {
    require(users[msg.sender].registered);
    projects[_projectId].link = link;
    return true;
    }
}