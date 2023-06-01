// Copyright 2023 The Pigweed Authors
//
// Licensed under the Apache License, Version 2.0 (the "License"); you may not
// use this file except in compliance with the License. You may obtain a copy of
// the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
// WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
// License for the specific language governing permissions and limitations under
// the License.

#![warn(clippy::all)]

mod other;

fn main() {
    println!("Hello, Pigweed!");

    // ensure we can run code from other modules in the main crate
    println!("{}", other::foo());

    // ensure we can run code from dependent libraries
    println!("{}", a::RequiredA::default().required_b.value);
    println!("{}", c::value());
}

#[cfg(test)]
mod tests {
    #[test]
    fn test_simple() {
        let x = 3.14;
        assert!(x > 0.0);
    }

    #[test]
    fn test_other_module() {
        assert!(a::RequiredA::default().required_b.value == 0);
    }
}
