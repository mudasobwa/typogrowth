Feature: Text is to be typographed (spacing and pubctuation are to be sanitized)

  # Known bug: see last example in first scenario outline
  Scenario Outline: Quotes and punctuation in English
    Given the input string is <input>
    When input string is processed with Typogrowl’s typography parser
    Then the typoed result should equal to <output>
    And the call to string’s typo should equal to <output>
    And neither single nor double quotes are left in the string

    Examples:
        | input                          | output                             |
        | "And God said \"∇×(∇×F) = ∇(∇·F) − ∇2F\" and there was light." | "And God said “∇×(∇×F) = ∇(∇·F) − ∇2F” and there was light." |
        | "And God said \"I--heard \"Booh \"Bah\" Booh\" and \"Bam\" in heaven\" and there was light." | "And God said “I—heard ‘Booh “Bah” Booh’ and ‘Bam’ in heaven” and there was light." |
        | "And God said \"I - heard \"Booh Bah Booh\" and \"Bam\" in heaven\" and there was light." | "And God said “I—heard ‘Booh Bah Booh’ and ‘Bam’ in heaven” and there was light." |
        | "And God said \"Oslo coordinates are: 59°57′N 10°45′E\" and there was light." | "And God said “Oslo coordinates are: 59°57′N 10°45′E” and there was light." |
        | "And God said \"That's a 6.3\" man, he sees sunsets at 10°20'30\" E.\" and there was light." | "And God said “That’s a 6.3″ man, he sees sunsets at 10°20′30″ E.” and there was light." |
        | "And God said \"Foo\" , and there was light." | "And God said “Foo,” and there was light." |
        | "And God said \"Baz heard 'Foos' Bar' once\" , and there was light." | "And God said “Baz heard ‘Foos’ Bar’ once,” and there was light." |
        | "And God, loving ellipsis, said.... And..." | "And God, loving ellipsis, said… And…" |

  Scenario Outline: Quotes and punctuation in Russian
    Given the input string is <input>
    When input string is processed with Typogrowl’s typography parser with lang "ru"
    Then the typoed result should equal to <output>
    And the call to string’s typo with lang "ru" should equal to <output>
    And neither single nor double quotes are left in the string

    Examples:
        | input                          | output                             |
        | "И Бог сказал: \"Я - слышу \"Бум\" и \"Бам\" где-то там\" , и стало светло." | "И Бог сказал: «Я — слышу „Бум“ и „Бам“ где-то там», и стало светло." |
        | "И Бог сказал: \"Я - слышу \"Бум \"и\" Бам\" где-то там\" , и стало светло." | "И Бог сказал: «Я — слышу „Бум «и» Бам“ где-то там», и стало светло." |
        | "Строка со ссылкой: http://wikipedia.org (ссылка)." | "Строка со ссылкой: http://wikipedia.org (ссылка)." |

  Scenario Outline: Spacing before/after punctuation
    Given the input string is <input>
    When input string is processed with Typogrowl’s typography parser
    Then the typoed result should equal to <output>
    And the call to string’s typo should equal to <output>

    Examples:
        | input                                  | output                                |
        | "It’s raining.Pity."                   | "It’s raining. Pity."                 |
        | "It’s raining . Pity."                 | "It’s raining. Pity."                 |
        | "It’s raining   .Pity."                | "It’s raining. Pity."                 |
        | "Link http://wikipedia.org here."      | "Link http://wikipedia.org here."     |
        | "Here is http://wikipedia.org. See?."  | "Here is http://wikipedia.org. See?." |
        | "Here is exclamation ellipsis!.."      | "Here is exclamation ellipsis!.."     |
        | "Here is exclamation ellipsis! . ."    | "Here is exclamation ellipsis!.."     |
        | "Here we go ; semicolon .. ."          | "Here we go; semicolon…"              |
        | "Here are ' english ' quotes . ."      | "Here are ‘english’ quotes.."         |
        | "Here are " english " quotes . ."      | "Here are “english” quotes.."         |
        | "Here we go : colon . ."               | "Here we go: colon.."                 |

  Scenario: Inplace string modification
    Given the input string is "Foo 'Bar' Baz"
    When input string is modified inplace with typo!
    Then typoed result should equal to "Foo “Bar” Baz"

  Scenario Outline: Orphans handling
    Given the input string is <input>
    When input string is processed with Typogrowl’s typography parser
    Then the typoed result should equal to <output>
    And the call to string’s typo should equal to <output>

    Examples:
        | input                                  | output                                |
        | "This is a cat."                       | "This is a cat."                      |

  Scenario Outline: Shadows handling
    Given the input string is <input>
    When input string is processed with Typogrowl’s typography parser
    Then the typoed result should equal to <output>
    And the call to string’s typo should equal to <output>

    Examples:
        | input                                  | output                                |
        | "<p><img src="http://mudasobwa.ru/i/self.jpg">Here: http://wikipedia.ru</p>" | "<p><img src="http://mudasobwa.ru/i/self.jpg">Here: http://wikipedia.ru</p>"                      |

