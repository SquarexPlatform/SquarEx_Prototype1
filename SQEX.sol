
// This is for Whitepaper only
contract SQEX {
    function totalSupply() constant returns (uint256 supply);
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    function lock(address _owner, uint256 amount);
    function unlock(address _owner, uint256 amount);
}

contract ProjectToken{
    function totalSupply() constant returns (uint256 supply);
    function balanceOf(address _owner) constant returns (uint256 balance);
    function transfer(address _to, uint256 _value) returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
    function approve(address _spender, uint256 _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint256 remaining);

    function lock(address _owner, uint256 amount);
    function unlock(address _owner, uint256 amount);
}

struct Stage {
     enum State = {
          Init,
          Development,
          Auditing,
          AuditingReportReady,
          ReviewReady,
          MoneyTransferred

     };
     Stage state = State.Init;

     address developer;
     address auditor;

     // info here...
}

contract PropertyBuyingOrBooking {
     enum State {
          Init,
          TokensTransferred,
          Booked,
          Bought,
          BookingReleased
     }
     State state = State.Init;

     address buyer;
     uint projectId;
     uint projectTokensBurnAmount;
     bool isBooking;
}

contract Project {
     enum State {
          Init,
          ProposalAttached,
          AuditingComplete,
          Approved,
          ISO_Started,
          ISO_Finished,
          Development,
          Finished
     }
     State state = State.Init;

     ProjectToken tokens;

     uint numProjectCurators;
     mapping (uint => address) projectCurators;

     uint bookings;
     mapping (uint => address) bookings;

     uint buys;
     mapping (uint => address) buys;

     address dueDilAuditor;
     address secondaryDueDilAuditor;
     string proposalLink;
     string secondaryProposalLink;

     uint numStages;
     mapping (uint => Stage) stages;

     function selectDueDilAuditor(address dueDilAuditor);
     function attachDueDilReport(string report);
     function voteForAuditingReport(uint report, bool acceptAuditing,bool acceptProposal);

     function becomeDeveloperOfStage(uint stageId,uint lockAmount);
     function becomeAuditorOfStage(uint stageId,uint lockAmount);

     // ProjectCurators
     function projectCuratorRequest(uint lockAmount);
     function nextProjectCuratorsElections();
     function resignProjectCuratorRequest(address projectCurator, string attachedInfo);
     function resignMe();

     // Secondary ISO
     function proposeSecondaryISO(string report);
     function selectSecondaryDueDilAuditor(address dueDilAuditor);
     function voteForSecondaryAuditingReport(uint report, bool acceptAuditing,bool acceptProposal);

     // Booking/Buying
     function requestBooking(uint projectId,uint tokensAmount);
     function requestBuying(uint projectId,uint tokensAmount);

     // Automatic functions
     function selectDevelopers();
     function selectAuditors();
     function startISO();
     function startSecondaryISO();
}

struct SeatRequest {
     address initiator;
     uint lockAmount;
     uint votes;
}

contract SquarExBranch is Auditing {
     mapping (uint => address) branchCurators;
     mapping (uint => address) acceptedAuditors;
     mapping (uint => address) acceptedDevelopers;
     mapping (uint => Project) projects;

     uint numBranchSeatRequests;
     mapping (uint => SeatRequest) branchCuratorsRequests;

     uint numAuditorRequests;
     mapping (uint => SeatRequest) auditorRequests;

// methods:
     // BranchCurators
     function branchCuratorRequest(uint lockAmount);
     function nextBranchCuratorsElections();
     function resignBranchCuratorRequest(address branchCurator, string attachedInfo);
     function resignMe();
     function voteForBranchCuratorResignment(address branchCurator,bool resign);
     
     // Auditors
     function becomeAuditorRequest(uint lockAmount);
     function acceptAuditorRequest(address auditor);
     function wantToDoDueDil(uint lockAmount);
     function resignAuditor();

     // Developers
     function newDevelopmentProposal(string proposalLink);

     // Params
     function parameterChangeProposal(string proposal,uint paramId,uint value);
     function voteForChangeProposal(uint proposalId, bool accept);
}

contract SquarExDAO {
     enum State {
          Init,
          ICO_Started,
          ICO_Finished
     }

     SQEX tokens; 

     // 10 max
     mapping (uint => address) superCurators;
     uint numSuperSeatRequests;
     mapping (uint => SeatRequest) superCuratorsRequests;

     uint numBranches;
     mapping (uint => SquarExBranch) branches;

// methods:
     // SuperCurators
     function superCuratorRequest(uint lockAmount);
     function nextSuperCuratorsElections();
     function resignSuperCuratorRequest(address superCurator, string attachedInfo);
     function resignMe();
     function voteForSuperCuratorResignment(address superCurator, bool resign);

     // Branches
     function addBranchProposal(SquarExBranch branch);
     function voteForBranchProposal(uint proposalId, bool accept);

     // Code Update
     function codeUpdateProposal(string proposal);
     function voteForUpdateProposal(uint proposalId, bool accept);

     // Buy-back
     function initiateBuyback();
}
