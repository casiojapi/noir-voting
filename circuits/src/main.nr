use dep::std;

fn main(root : pub Field, index : Field, hash_path : [Field; 2], secret: Field, proposal_id: pub Field) -> pub Field {
    // note commitment 
    let note_commitment = std::hash::pedersen_commitment([secret]);

    // build nullifier
    let nullifier = std::hash::pedersen_commitment([root, secret, proposalId]);

    // check root
    let check_root = std::merkle::compute_merkle_root(note_commitment[0], index, hash_path);
    assert(root == check_root);

    // send nullifier
    nullifier[0]
}


#[test]
fn test_valid_build_merkle_tree() {
    // build merkle
    let commitment_0 = std::hash::pedersen_commitment([1])[0];
    let commitment_1 = std::hash::pedersen_commitment([2])[0];
    let commitment_2 = std::hash::pedersen_commitment([3])[0];
    let commitment_3 = std::hash::pedersen_commitment([4])[0];

    // left 
    let left_branch = std::hash::pedersen_commitment([commitment_0, commitment_1])[0];

    // right 
    let right_branch = std::hash::pedersen_commitment([commitment_2, commitment_3])[0];
    
    // root-hash
    let root = std::hash::pedersen_commitment([left_branch, right_branch])[0];

    let proposal_id = 0;
    
    let nullifier = main(
      root,
      0,
      [commitment_1, right_branch],
      1,
      proposal_id
    );

    let expected_nullifier = std::hash::pedersen([root, 1, proposal_id]);

    assert(nullifier == expected_nullifier[0]);
}
