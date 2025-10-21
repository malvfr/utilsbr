import gleam/int
import gleam/list
import gleam/string

/// Converts a character (letter or digit) to its ASCII value minus 48.
///
/// This is used for the check digit calculation as per Receita Federal specifications.
/// For digits: '0' (ASCII 48) -> 0, '1' (ASCII 49) -> 1, etc.
/// For letters: 'A' (ASCII 65) -> 17, 'B' (ASCII 66) -> 18, etc.
fn char_to_value(char: String) -> Result(Int, Nil) {
  case string.to_utf_codepoints(char) |> list.first {
    Ok(codepoint) -> {
      let ascii_value = string.utf_codepoint_to_int(codepoint)
      Ok(ascii_value - 48)
    }
    Error(_) -> Error(Nil)
  }
}

fn calculate_first_verification_digit_alphanumeric(
  first_twelve_chars: List(String),
) -> Result(Int, Nil) {
  let verifying_digits = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  let sum_result =
    list.zip(first_twelve_chars, verifying_digits)
    |> list.try_fold(0, fn(acc, pair) {
      let #(char, weight) = pair
      case char_to_value(char) {
        Ok(value) -> Ok(acc + value * weight)
        Error(_) -> Error(Nil)
      }
    })

  case sum_result {
    Ok(sum) -> {
      let remainder = sum % 11
      Ok(calculate_verification_digit(remainder))
    }
    Error(_) -> Error(Nil)
  }
}

fn calculate_second_verification_digit_alphanumeric(
  thirteen_chars: List(String),
) -> Result(Int, Nil) {
  let verifying_digits = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

  let sum_result =
    list.zip(thirteen_chars, verifying_digits)
    |> list.try_fold(0, fn(acc, pair) {
      let #(char, weight) = pair
      case char_to_value(char) {
        Ok(value) -> Ok(acc + value * weight)
        Error(_) -> Error(Nil)
      }
    })

  case sum_result {
    Ok(sum) -> {
      let remainder = sum % 11
      Ok(calculate_verification_digit(remainder))
    }
    Error(_) -> Error(Nil)
  }
}

/// Calculates a verification digit from a modulo 11 remainder.
fn calculate_verification_digit(remainder: Int) -> Int {
  case remainder {
    0 -> 0
    1 -> 0
    _ -> 11 - remainder
  }
}

/// Validates an alphanumeric CNPJ using the modulo 11 algorithm.
///
/// The CNPJ must be exactly 14 characters long, with the first 12 positions
/// containing letters (A-Z) and/or digits (0-9), and the last 2 positions
/// containing only numeric verification digits.
pub fn validate_alphanumeric(cnpj: String) -> Bool {
  case string.length(cnpj) {
    14 -> validate_alphanumeric_structure(cnpj)
    _ -> False
  }
}

fn validate_alphanumeric_structure(cnpj: String) -> Bool {
  let first_twelve = string.slice(cnpj, 0, 12) |> string.split("")
  let last_two = string.slice(cnpj, 12, 2)

  case
    calculate_first_verification_digit_alphanumeric(first_twelve),
    int.parse(last_two |> string.slice(0, 1)),
    int.parse(last_two |> string.slice(1, 1))
  {
    Ok(first_dv), Ok(actual_first_dv), Ok(actual_second_dv) -> {
      case first_dv == actual_first_dv {
        True -> {
          let thirteen_chars =
            list.append(first_twelve, [int.to_string(first_dv)])
          case
            calculate_second_verification_digit_alphanumeric(thirteen_chars)
          {
            Ok(second_dv) -> second_dv == actual_second_dv
            Error(_) -> False
          }
        }
        False -> False
      }
    }
    _, _, _ -> False
  }
}
