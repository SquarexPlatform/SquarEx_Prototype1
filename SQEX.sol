/*
* This is a prototype of interaces for SquarEx project.
*    This is just to depict how the contracts will be used later.
*    This is not a working production-ready contract code.
* 
*    Of course, SquarEx will evolve and move from the prototype
*    to production ready system.
*
*    There are still more function to implement.
*/ 

// This is a main SQEX token contract
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

// This is a Project token contract (different for each project on a SquarEx platform) 
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

contract MortgageRequest {
     enum State {
          Init,
          TokensTransferred,
          MortgageCancelled,
          MortgageCompleted
     }
     State state = State.Init;

     address lender;
     address borrower;

     uint projectId;
     uint projectTokensRequestAmount;
     uint interestRate;
}

// The development project is initiated by the Developer
// 
// 1. The Developer prepares special formatted document using SquarEx platform 
//   - “the proposal” (see format details above);
// 2. The Developer uploads the proposal to the SquarEx and pays $40K + $80K fees in SQEX tokens;
// 3. Due diligence auditor is selected from the list by two BranchCurators and accepts the offer;
// 4. Auditor does the due diligence: checks the proposal, modifies and improves it effectively adding necessary stages and details. 
// 5. The auditing report is published; 
// 6. BranchCurators accept or reject the proposal;
// 7. For each development stage: the Developer is selected (see below). 
// 8. Stage costs can be changed here.
// 9. For each development stage: the Auditor is selected (see below).
// 10. Auditor rewards can be changed here.
// 11. Total cost of the development is calculated;
// 12. Once the final proposal is ready and all necessary information is provided and set, SquarEx starts ISO of the project;
// 13. ISO either finishes successfully or fails.
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

     function selectDueDilAuditor(address dueDilAuditor)byBranchCurators;
     // Auditors do the auditing checks after the development stage is finished. 
     // Auditors should send the auditor’s report to the SquarEx. 
     // Each stage auditing report is then checked and approved by ProjectCurators.
     function attachDueDilReport(string report)byAuditor;
     // After development stage is completed and Auditor published a stage auditing report 
     // -> ProjectCurators of the current project should check it and vote
     function voteForAuditingReport(uint report, bool acceptAuditing,bool acceptProposal)byBranchCurators;
     function becomeDeveloperOfStage(uint stageId,uint lockAmount)byTokenHolders;
     // Auditor can become an Auditor of a selected project stage while project is in 
     // ‘waiting for developers’ stage (by default, for 30 days). 
     // Auditor should be an accepted by BranchCurators of the current branch 
     // (see ‘Becoming an auditor’ scenario).
     function becomeAuditorOfStage(uint stageId,uint lockAmount)byTokenHolders;
     // Auditor of can request resignment from doing the current stage auditing
     function resignAuditorOfStage(uint stageId,uint lockAmount)byAuditor;

     // ProjectCurators
     function projectCuratorRequest(uint lockAmount)byProjectTokenHolders;
     function resignProjectCuratorRequest(address projectCurator, string attachedInfo)byProjectTokenHolders;
     // Any ProjectCurator can request a resignment of himself:w
     function resignMe()byProjectCurators;
     function nextProjectCuratorsElections();

     // Secondary ISO
     // Any ProjectCurator can add a special proposal to start a Secondary ISO 
     // to get extra funding to complete the project.
     function proposeSecondaryISO(string report)byProjectCurators;
     // Due diligence auditor is selected from the list by two BranchCurators of the current 
     // branch and accepts the offer
     function selectSecondaryDueDilAuditor(address dueDilAuditor)byProjectCurators;
     // BranchCurators of the current branch accept or reject the audit report and proposal (vote for 10 days)
     function voteForSecondaryAuditingReport(uint report, bool acceptAuditing,bool acceptProposal)byProjectCurators;

     // Booking/Buying
     // Any Project Token Holder can book a real estate property. 
     // In this case his project tokens are not burned (as in ‘buying a real estate property’ scenario). 
     // He can later cancel the booking.
     function requestBooking(uint projectId,uint tokensAmount)byProjectTokenHolders;
     function cancelBooking(uint projectId,uint tokensAmount)byProjectTokenHolders;
     function requestBuying(uint projectId,uint tokensAmount)byProjectTokenHolders;

     // Automatic functions
     function selectDevelopers();
     function selectAuditors();
     function startISO();
     function startSecondaryISO();

     // Request Mortgage
     // Any Project Token Holder can request a mortgage if own at least 20% 
     // (by default, can be changed by BranchCurators) of a property
     function requestMortgage()byProjectTokenHolders;
     // Any Project Token Holder can provide a mortgage to the Borrower to get an interest
     // First he  sets basic parameters and then waits for acceptance by the Borrower
     function addMortgageOffer(uint mortgageId, uint interestRate)byProjectTokenHolders;
     // After Lender added a mortgage offer Borrower should now accept it
     function acceptMortgageOffer(uint mortgageId)byProjectTokenHolders;
     // Borrower should repay his mortgage regularly
     function repayMortgage(uint mortgageId)byProjectTokenHolders;
     function completeMortgage(uint mortgageId)byProjectTokenHolders; 
}

struct SeatRequest {
     address initiator;
     uint lockAmount;
     uint votes;
}

// Anybody can fork this code
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
     // Any SQEX token holder can become a BranchCurator
     function branchCuratorRequest(uint lockAmount)byTokenHolders;
     // Any SQEX token holder can add a proposal to resign BranchCurator
     function resignBranchCuratorRequest(address branchCurator, string attachedInfo)byTokenHolders;
     // Any BranchCurator can request a resignment of himself
     function resignMe()byBranchCurators;
     // SuperCurators review the proposal and vote for 30 days
     // There is no need to vote ‘positive’ (that is the default answer)
     function voteForBranchCuratorResignment(address branchCurator,bool resign)bySuperCurators;
     function nextBranchCuratorsElections();
     
     // Auditors
     // Any SQEX token holder can become an Auditor of the branch
     function becomeAuditorRequest(uint lockAmount)byTokenHolders;
     // Any two BranchCurators should accept the request
     function acceptAuditorRequest(address auditor)byBranchCurators;
     function wantToDoDueDil(uint lockAmount)byAuditor;
     function resignAuditor()byAuditor;
     // SQEX token holders vote for 30 days
     function voteForBranchAuditorResignment(address branchCurator,bool resign)byTokenHolders;

     // Developers
     // Any SQEX token holder can add a new development project proposal
     function newDevelopmentProposal(string proposalLink)byTokenHolders;

     // Params
     function parameterChangeProposal(string proposal,uint paramId,uint value)byBranchCurators;
     function voteForChangeProposal(uint proposalId, bool accept)byBranchCurators;
}

// This is the main DAO contract code
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
     // Any SQEX token holder can become a SuperCurator
     function superCuratorRequest(uint lockAmount)byTokenHolders;
     // Any SQEX token holder can add a proposal to resign SuperCurator
     function resignSuperCuratorRequest(address superCurator, string attachedInfo)byTokenHolders;
     // Any SuperCurator can request a resignment of himself
     function resignMe()bySuperCurators;
     // SQEX token holders vote for 30 days
     function voteForSuperCuratorResignment(address superCurator, bool resign)byTokenHolders;
     function nextSuperCuratorsElections();

     // Branches
     // Any SQEX token holder can request a new branch addition
     function addBranchProposal(SquarExBranch branch)byTokenHolder;
     // Any SQEX token holder can request a new branch addition
     function voteForBranchProposal(uint proposalId, bool accept)bySuperCurators;

     // Code Update
     // Any SuperCurator can request a code update
     function codeUpdateProposal(string proposal)bySuperCurators;
     // SQEX token holders and project token holders review the new code and vote for 4 weeks
     function voteForUpdateProposal(uint proposalId, bool accept)byTokenHolders;

     // Buy-back
     // The buy back is a regular process that is started automatically by the SquarEx DAO code. 
     // SquarEx buy back fund is used to buy tokens. If it is empty - no buy back occurs.
     // During the buy-back an offer to buy a SQEX tokens is added to the Exchange. 
     // Any SQEX token holder can sell his tokens at a fair price and get ETH in return.
     function initiateBuyback();
}
