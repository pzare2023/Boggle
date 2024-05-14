#![allow(non_snake_case,non_camel_case_types,dead_code)]

use std::collections::HashMap;
use std::convert::TryInto;

/*
    Fill in the boggle function below. Use as many helpers as you want.
    Test your code by running 'cargo test' from the tester_rs_simple directory.
    
    To demonstrate how the HashMap can be used to store word/coord associations,
    the function stub below contains two sample words added from the 2x2 board.
*/



#[derive(Default)]
struct TrieNode {
    children: HashMap<char, TrieNode>,
    is_word_end: bool,
}

impl TrieNode {
    fn new() -> Self {
        Default::default()
    }

  
    fn insert(&mut self, word: &str) {
        let mut node = self;
        for ch in word.chars() {
            node = node.children.entry(ch).or_insert_with(TrieNode::new);
        }
        node.is_word_end = true;
    }

    fn search(&self, word: &str) -> bool {
        let mut node = self;
        for ch in word.chars() {
            match node.children.get(&ch) {
                Some(n) => node = n,
                None => return false,
            }
        }
        node.is_word_end
    }


    fn starts_with(&self, prefix: &str) -> bool {
        let mut node = self;
        for ch in prefix.chars() {
            match node.children.get(&ch) {
                Some(n) => node = n,
                None => return false,
            }
        }
        true
    }
}


fn boggle(board: & [&str], words: & Vec<String>) -> HashMap<String, Vec<(u8, u8)>>
{
    let mut found: HashMap<String, Vec<(u8, u8)>> = HashMap::new();
    let mut trie = TrieNode::new();
    for word in words {
        trie.insert(word);
    }
    let mut visited: Vec<Vec<bool>> = vec![vec![false; board[0].len()]; board.len()];

    for i in 0..board.len(){
        for j in 0..board.len(){
            dfs (&board, i, j, &mut visited, &mut String::new(),&mut Vec::new(), &trie, &mut found);
        }
    }
    

    found
}

fn dfs(
    board:&[&str],
    i: usize,
    j: usize,
    visited: &mut Vec<Vec<bool>>,
    current_word: &mut String,
    current_path: &mut Vec<(u8, u8)>,
    trie: &TrieNode,
    found: &mut HashMap<String, Vec<(u8, u8)>>
){
    if visited[i][j]{
        return;
    }
    visited[i][j] = true;
    current_word.push(board[i].as_bytes()[j] as char);
    current_path.push((i as u8, j as u8));

    if current_word.len()>=2 && trie.search(current_word) {
        found.entry(current_word.clone())
        .or_insert_with(|| current_path.clone());
    }

    if trie.starts_with(current_word){
            const DELTAS: [(isize, isize); 8] = [
            (-1, -1), (-1, 0), (-1, 1),
            (0, -1),           (0, 1),
            (1, -1), (1, 0), (1, 1),
        ];

        for (di, dj) in DELTAS {
            let new_i = i as isize + di;
            let new_j = j as isize + dj;
            
            if new_i >= 0 && new_i < board.len() as isize && new_j >= 0 && new_j < board[new_i as usize].len() as isize {
                if let Ok(new_i_usize) = new_i.try_into() {
                    if let Ok(new_j_usize) = new_j.try_into() {
                        dfs(board, new_i_usize, new_j_usize, visited, current_word, current_path, trie, found);
                    }
                }
            }
        }
    }


    
    
    visited[i][j] = false;
    current_word.pop();
    current_path.pop();
}
    
#[cfg(test)]
#[path = "tests.rs"]
mod tests;

