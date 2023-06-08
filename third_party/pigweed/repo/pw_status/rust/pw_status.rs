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

//! # pw_status
//!
//! Rust error types using error codes compatible with Pigweed's
//! [pw_status](https://pigweed.dev/pw_status).  In order to keep the interface
//! idiomatic for Rust, `PW_STATUS_OK` is omitted from the Error enum and a
//! `StatusCode` trait is provided to turn a `Result` into a canonical
//! status code.
//!
//! For an in depth explanation of the values of the `Error` enum, see
//! the [Pigweed status codes documentation](https://pigweed.dev/pw_status/#status-codes).
//!
//! # Example
//!
//! ```
//! use pw_status::{Error, Result};
//!
//! fn div(numerator: u32, denominator: u32) -> Result<u32> {
//!     if denominator == 0 {
//!         Err(Error::FailedPrecondition)
//!     } else {
//!         Ok(numerator / denominator)
//!     }
//! }
//!
//! assert_eq!(div(4, 2), Ok(2));
//! assert_eq!(div(4, 0), Err(Error::FailedPrecondition));
//! ```

#![cfg_attr(feature = "std", no_std)]

/// Status code for no error.
pub const OK: u32 = 0;

#[cfg_attr(feature = "std", derive(Debug))]
#[derive(Eq, PartialEq)]
/// Error type compatible with Pigweed's [pw_status](https://pigweed.dev/pw_status).
///
/// For an in depth explanation of the values of the `Error` enum, see
/// the [Pigweed status codes documentation](https://pigweed.dev/pw_status/#status-codes).
pub enum Error {
    Cancelled = 1,
    Unknown = 2,
    InvalidArgument = 3,
    DeadlineExceeded = 4,
    NotFound = 5,
    AlreadyExists = 6,
    PermissionDenied = 7,
    ResourceExhausted = 8,
    FailedPrecondition = 9,
    Aborted = 10,
    OutOfRange = 11,
    Unimplemented = 12,
    Internal = 13,
    Unavailable = 14,
    DataLoss = 15,
    Unauthenticated = 16,
}

pub type Result<T> = core::result::Result<T, Error>;

/// Convert a Result into an status code.
pub trait StatusCode {
    /// Return a pigweed compatible status code.
    fn status_code(self) -> u32;
}

impl<T> StatusCode for Result<T> {
    fn status_code(self) -> u32 {
        match self {
            Ok(_) => OK,
            Err(e) => e as u32,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn test_status_code() {
        assert_eq!(Result::Ok(()).status_code(), 0);
        assert_eq!(Result::<()>::Err(Error::Cancelled).status_code(), 1);
        assert_eq!(Result::<()>::Err(Error::Unknown).status_code(), 2);
        assert_eq!(Result::<()>::Err(Error::InvalidArgument).status_code(), 3);
        assert_eq!(Result::<()>::Err(Error::DeadlineExceeded).status_code(), 4);
        assert_eq!(Result::<()>::Err(Error::NotFound).status_code(), 5);
        assert_eq!(Result::<()>::Err(Error::AlreadyExists).status_code(), 6);
        assert_eq!(Result::<()>::Err(Error::PermissionDenied).status_code(), 7);
        assert_eq!(Result::<()>::Err(Error::ResourceExhausted).status_code(), 8);
        assert_eq!(
            Result::<()>::Err(Error::FailedPrecondition).status_code(),
            9
        );
        assert_eq!(Result::<()>::Err(Error::Aborted).status_code(), 10);
        assert_eq!(Result::<()>::Err(Error::OutOfRange).status_code(), 11);
        assert_eq!(Result::<()>::Err(Error::Unimplemented).status_code(), 12);
        assert_eq!(Result::<()>::Err(Error::Internal).status_code(), 13);
        assert_eq!(Result::<()>::Err(Error::Unavailable).status_code(), 14);
        assert_eq!(Result::<()>::Err(Error::DataLoss).status_code(), 15);
        assert_eq!(Result::<()>::Err(Error::Unauthenticated).status_code(), 16);
    }
}
