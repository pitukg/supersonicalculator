# SupersoniCalculator
Simple arithmetics lexer parser and evaluator in OCaml.

This was an optional "coursework", if you have the same coursework, please __do not copy__.

### Lexer
Written from scratch based on a state machine.
Supports the following tokens:
- `number` (calculating the value on-the-go)
- `left bracket`
- `right bracket`
- `factorial`
- `cosine`
- `multiplication`
- `plus`
- `minus`
- `End-of-File`

### Parser
Shift-reduce parser based on the LR(0) automaton. (Also written from scratch, see implementation in `parser.ml`.)
The tables driving the parser have been calculated by hand based on a context-free grammar.

### Example outputs

#### Small example output

Given input `cos (1-0.!)!` the parse tree output is:
```
( <Expression> : Cos ( 1. - 0. ! ) ! = 0.540302 ) [
  ( <Term> : Cos ( 1. - 0. ! ) ! = 0.540302 ) [
    ( <Factor> : Cos ( 1. - 0. ! ) ! = 0.540302 ) [
      ( <Cos> )
      ( <Factor> : ( 1. - 0. ! ) ! = 1.000000 ) [
        ( <Cosine Argument> : ( 1. - 0. ! ) ! = 1.000000 ) [
          ( <Cosine Argument> : ( 1. - 0. ! ) = -0.000000 ) [
            ( <Factorial Argument> : ( 1. - 0. ! ) = -0.000000 ) [
              ( <Unsigned Number> : ( 1. - 0. ! ) = -0.000000 ) [
                ( <(> )
                ( <Expression> : 1. - 0. ! = -0.000000 ) [
                  ( <Expression> : 1. = 1.000000 ) [
                    ( <Term> : 1. = 1.000000 ) [
                      ( <Factor> : 1. = 1.000000 ) [
                        ( <Cosine Argument> : 1. = 1.000000 ) [
                          ( <Factorial Argument> : 1. = 1.000000 ) [
                            ( <Unsigned Number> : 1. = 1.000000 ) [
                              ( <Number> : 1. = 1.000000 )
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                  ( <-> )
                  ( <Term> : 0. ! = 1.000000 ) [
                    ( <Factor> : 0. ! = 1.000000 ) [
                      ( <Cosine Argument> : 0. ! = 1.000000 ) [
                        ( <Cosine Argument> : 0. = 0.000000 ) [
                          ( <Factorial Argument> : 0. = 0.000000 ) [
                            ( <Unsigned Number> : 0. = 0.000000 ) [
                              ( <Number> : 0. = 0.000000 )
                            ]
                          ]
                        ]
                        ( <!> )
                      ]
                    ]
                  ]
                ]
                ( <)> )
              ]
            ]
          ]
          ( <!> )
        ]
      ]
    ]
  ]
]
```


#### Large example output

Given input `2*(.7+ cos  cos(1+2!) - 1 - cos 3!!+ 1)*(1+2*(1-2!*cos .1))` the parse tree output is:
```
( <Expression> : 2. * ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) * ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -4.092030 ) [
  ( <Term> : 2. * ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) * ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -4.092030 ) [
    ( <Factor> : 2. = 2.000000 ) [
      ( <Cosine Argument> : 2. = 2.000000 ) [
        ( <Factorial Argument> : 2. = 2.000000 ) [
          ( <Unsigned Number> : 2. = 2.000000 ) [
            ( <Number> : 2. = 2.000000 )
          ]
        ]
      ]
    ]
    ( <*> )
    ( <Term> : ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) * ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -2.046015 ) [
      ( <Factor> : ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) = 2.087735 ) [
        ( <Cosine Argument> : ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) = 2.087735 ) [
          ( <Factorial Argument> : ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) = 2.087735 ) [
            ( <Unsigned Number> : ( 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. ) = 2.087735 ) [
              ( <(> )
              ( <Expression> : 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! + 1. = 2.087735 ) [
                ( <Expression> : 0.7 + Cos Cos ( 1. + 2. ! ) - 1. - Cos 3. ! ! = 1.087735 ) [
                  ( <Expression> : 0.7 + Cos Cos ( 1. + 2. ! ) - 1. = 0.248696 ) [
                    ( <Expression> : 0.7 + Cos Cos ( 1. + 2. ! ) = 1.248696 ) [
                      ( <Expression> : 0.7 = 0.700000 ) [
                        ( <Term> : 0.7 = 0.700000 ) [
                          ( <Factor> : 0.7 = 0.700000 ) [
                            ( <Cosine Argument> : 0.7 = 0.700000 ) [
                              ( <Factorial Argument> : 0.7 = 0.700000 ) [
                                ( <Unsigned Number> : 0.7 = 0.700000 ) [
                                  ( <Number> : 0.7 = 0.700000 )
                                ]
                              ]
                            ]
                          ]
                        ]
                      ]
                      ( <+> )
                      ( <Term> : Cos Cos ( 1. + 2. ! ) = 0.548696 ) [
                        ( <Factor> : Cos Cos ( 1. + 2. ! ) = 0.548696 ) [
                          ( <Cos> )
                          ( <Factor> : Cos ( 1. + 2. ! ) = -0.989992 ) [
                            ( <Cos> )
                            ( <Factor> : ( 1. + 2. ! ) = 3.000000 ) [
                              ( <Cosine Argument> : ( 1. + 2. ! ) = 3.000000 ) [
                                ( <Factorial Argument> : ( 1. + 2. ! ) = 3.000000 ) [
                                  ( <Unsigned Number> : ( 1. + 2. ! ) = 3.000000 ) [
                                    ( <(> )
                                    ( <Expression> : 1. + 2. ! = 3.000000 ) [
                                      ( <Expression> : 1. = 1.000000 ) [
                                        ( <Term> : 1. = 1.000000 ) [
                                          ( <Factor> : 1. = 1.000000 ) [
                                            ( <Cosine Argument> : 1. = 1.000000 ) [
                                              ( <Factorial Argument> : 1. = 1.000000 ) [
                                                ( <Unsigned Number> : 1. = 1.000000 ) [
                                                  ( <Number> : 1. = 1.000000 )
                                                ]
                                              ]
                                            ]
                                          ]
                                        ]
                                      ]
                                      ( <+> )
                                      ( <Term> : 2. ! = 2.000000 ) [
                                        ( <Factor> : 2. ! = 2.000000 ) [
                                          ( <Cosine Argument> : 2. ! = 2.000000 ) [
                                            ( <Cosine Argument> : 2. = 2.000000 ) [
                                              ( <Factorial Argument> : 2. = 2.000000 ) [
                                                ( <Unsigned Number> : 2. = 2.000000 ) [
                                                  ( <Number> : 2. = 2.000000 )
                                                ]
                                              ]
                                            ]
                                            ( <!> )
                                          ]
                                        ]
                                      ]
                                    ]
                                    ( <)> )
                                  ]
                                ]
                              ]
                            ]
                          ]
                        ]
                      ]
                    ]
                    ( <-> )
                    ( <Term> : 1. = 1.000000 ) [
                      ( <Factor> : 1. = 1.000000 ) [
                        ( <Cosine Argument> : 1. = 1.000000 ) [
                          ( <Factorial Argument> : 1. = 1.000000 ) [
                            ( <Unsigned Number> : 1. = 1.000000 ) [
                              ( <Number> : 1. = 1.000000 )
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                  ( <-> )
                  ( <Term> : Cos 3. ! ! = -0.839039 ) [
                    ( <Factor> : Cos 3. ! ! = -0.839039 ) [
                      ( <Cos> )
                      ( <Factor> : 3. ! ! = 720.000000 ) [
                        ( <Cosine Argument> : 3. ! ! = 720.000000 ) [
                          ( <Cosine Argument> : 3. ! = 6.000000 ) [
                            ( <Cosine Argument> : 3. = 3.000000 ) [
                              ( <Factorial Argument> : 3. = 3.000000 ) [
                                ( <Unsigned Number> : 3. = 3.000000 ) [
                                  ( <Number> : 3. = 3.000000 )
                                ]
                              ]
                            ]
                            ( <!> )
                          ]
                          ( <!> )
                        ]
                      ]
                    ]
                  ]
                ]
                ( <+> )
                ( <Term> : 1. = 1.000000 ) [
                  ( <Factor> : 1. = 1.000000 ) [
                    ( <Cosine Argument> : 1. = 1.000000 ) [
                      ( <Factorial Argument> : 1. = 1.000000 ) [
                        ( <Unsigned Number> : 1. = 1.000000 ) [
                          ( <Number> : 1. = 1.000000 )
                        ]
                      ]
                    ]
                  ]
                ]
              ]
              ( <)> )
            ]
          ]
        ]
      ]
      ( <*> )
      ( <Term> : ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -0.980017 ) [
        ( <Factor> : ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -0.980017 ) [
          ( <Cosine Argument> : ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -0.980017 ) [
            ( <Factorial Argument> : ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -0.980017 ) [
              ( <Unsigned Number> : ( 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) ) = -0.980017 ) [
                ( <(> )
                ( <Expression> : 1. + 2. * ( 1. - 2. ! * Cos 0.1 ) = -0.980017 ) [
                  ( <Expression> : 1. = 1.000000 ) [
                    ( <Term> : 1. = 1.000000 ) [
                      ( <Factor> : 1. = 1.000000 ) [
                        ( <Cosine Argument> : 1. = 1.000000 ) [
                          ( <Factorial Argument> : 1. = 1.000000 ) [
                            ( <Unsigned Number> : 1. = 1.000000 ) [
                              ( <Number> : 1. = 1.000000 )
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                  ( <+> )
                  ( <Term> : 2. * ( 1. - 2. ! * Cos 0.1 ) = -1.980017 ) [
                    ( <Factor> : 2. = 2.000000 ) [
                      ( <Cosine Argument> : 2. = 2.000000 ) [
                        ( <Factorial Argument> : 2. = 2.000000 ) [
                          ( <Unsigned Number> : 2. = 2.000000 ) [
                            ( <Number> : 2. = 2.000000 )
                          ]
                        ]
                      ]
                    ]
                    ( <*> )
                    ( <Term> : ( 1. - 2. ! * Cos 0.1 ) = -0.990008 ) [
                      ( <Factor> : ( 1. - 2. ! * Cos 0.1 ) = -0.990008 ) [
                        ( <Cosine Argument> : ( 1. - 2. ! * Cos 0.1 ) = -0.990008 ) [
                          ( <Factorial Argument> : ( 1. - 2. ! * Cos 0.1 ) = -0.990008 ) [
                            ( <Unsigned Number> : ( 1. - 2. ! * Cos 0.1 ) = -0.990008 ) [
                              ( <(> )
                              ( <Expression> : 1. - 2. ! * Cos 0.1 = -0.990008 ) [
                                ( <Expression> : 1. = 1.000000 ) [
                                  ( <Term> : 1. = 1.000000 ) [
                                    ( <Factor> : 1. = 1.000000 ) [
                                      ( <Cosine Argument> : 1. = 1.000000 ) [
                                        ( <Factorial Argument> : 1. = 1.000000 ) [
                                          ( <Unsigned Number> : 1. = 1.000000 ) [
                                            ( <Number> : 1. = 1.000000 )
                                          ]
                                        ]
                                      ]
                                    ]
                                  ]
                                ]
                                ( <-> )
                                ( <Term> : 2. ! * Cos 0.1 = 1.990008 ) [
                                  ( <Factor> : 2. ! = 2.000000 ) [
                                    ( <Cosine Argument> : 2. ! = 2.000000 ) [
                                      ( <Cosine Argument> : 2. = 2.000000 ) [
                                        ( <Factorial Argument> : 2. = 2.000000 ) [
                                          ( <Unsigned Number> : 2. = 2.000000 ) [
                                            ( <Number> : 2. = 2.000000 )
                                          ]
                                        ]
                                      ]
                                      ( <!> )
                                    ]
                                  ]
                                  ( <*> )
                                  ( <Term> : Cos 0.1 = 0.995004 ) [
                                    ( <Factor> : Cos 0.1 = 0.995004 ) [
                                      ( <Cos> )
                                      ( <Factor> : 0.1 = 0.100000 ) [
                                        ( <Cosine Argument> : 0.1 = 0.100000 ) [
                                          ( <Factorial Argument> : 0.1 = 0.100000 ) [
                                            ( <Unsigned Number> : 0.1 = 0.100000 ) [
                                              ( <Number> : 0.1 = 0.100000 )
                                            ]
                                          ]
                                        ]
                                      ]
                                    ]
                                  ]
                                ]
                              ]
                              ( <)> )
                            ]
                          ]
                        ]
                      ]
                    ]
                  ]
                ]
                ( <)> )
              ]
            ]
          ]
        ]
      ]
    ]
  ]
]
```
