module MyModule::Crowdfunding {

    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct to store crowdfunding project data
    struct Project has key, store {
        total_funds: u64,
        goal: u64,
    }

    /// Create a new crowdfunding project with a goal
    public fun create_project(creator: &signer, goal: u64) {
        let project = Project {
            total_funds: 0,
            goal,
        };
        move_to<Project>(creator, project);
    }

    /// Allow users to contribute APT to an existing project
    public fun contribute(contributor: &signer, owner_addr: address, amount: u64) acquires Project {
        let project = borrow_global_mut<Project>(owner_addr);
        let coins = coin::withdraw<AptosCoin>(contributor, amount);
        coin::deposit<AptosCoin>(owner_addr, coins);
        project.total_funds = project.total_funds + amount;
    }
}