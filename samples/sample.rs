//! Rust sample for syntax highlighting.

use std::collections::HashMap;
use std::fmt;

const MAX_DEPTH: usize = 8;

/// A node in a simple expression tree.
#[derive(Debug, Clone, PartialEq)]
pub enum Expr {
    Num(f64),
    Var(String),
    Add(Box<Expr>, Box<Expr>),
    Mul(Box<Expr>, Box<Expr>),
}

impl Expr {
    pub fn eval(&self, env: &HashMap<String, f64>) -> Result<f64, String> {
        match self {
            Expr::Num(value) => Ok(*value),
            Expr::Var(name) => env
                .get(name)
                .copied()
                .ok_or_else(|| format!("unbound variable: {name}")),
            Expr::Add(lhs, rhs) => Ok(lhs.eval(env)? + rhs.eval(env)?),
            Expr::Mul(lhs, rhs) => Ok(lhs.eval(env)? * rhs.eval(env)?),
        }
    }
}

impl fmt::Display for Expr {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Expr::Num(value) => write!(formatter, "{value}"),
            Expr::Var(name) => write!(formatter, "{name}"),
            Expr::Add(lhs, rhs) => write!(formatter, "({lhs} + {rhs})"),
            Expr::Mul(lhs, rhs) => write!(formatter, "({lhs} * {rhs})"),
        }
    }
}

fn main() {
    let mut env = HashMap::new();
    env.insert("x".to_string(), 3.0_f64);

    let expr = Expr::Add(
        Box::new(Expr::Mul(Box::new(Expr::Num(2.0)), Box::new(Expr::Var("x".into())))),
        Box::new(Expr::Num(1.0)),
    );

    assert!(MAX_DEPTH > 0);
    match expr.eval(&env) {
        Ok(result) => println!("{expr} = {result}"),
        Err(message) => eprintln!("error: {message}"),
    }
}
