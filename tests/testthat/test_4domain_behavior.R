library(DNAr)
context('CRN behavior on 4-domain approach')

run_reaction_4domain <- function(parms, filename, save = FALSE) {
    result <- do.call(react_4domain, parms)
    behavior <- result$behavior
    if(save) {
        save_behavior_csv(behavior, filename)
    } else {
        behavior_ok <- load_behavior_csv(filename)
        return(list(behavior, behavior_ok))
    }
}

test_that(
    'react_4domain reproduces correctly the behavior of the
    reaction A + B -> C',
    {
        parms <- list(
            species   = c('A', 'B', 'C'),
            ci        = c(1e3, 1e3, 0),
            reactions = c('A + B -> C'),
            ki        = c(1e-7),
            qmax      = 1e-3,
            cmax      = 1e5,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 72000, 10)
        )
        behaviors <- run_reaction_4domain(parms, 'data/behavior_ApBeC_4domain')
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction A -> B',
    {
        parms <- list(
            species   = c('A', 'B'),
            ci        = c(1e4, 0),
            reactions = c('A -> B'),
            ki        = c(5e-5 / 1e5),
            qmax      = 1e-5,
            cmax      = 1e5,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 72000, 10)
        )
        behaviors <- run_reaction_4domain(parms, 'data/behavior_AeB_4domain')
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction 0 -> A',
    {
        parms <- list(
            species   = c('A'),
            ci        = c(0),
            reactions = c('0 -> A'),
            ki        = c(2),
            qmax      = 1e3,
            cmax      = 1e4,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_0eA_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction 0 -> 2A',
    {
        parms <- list(
            species   = c('A'),
            ci        = c(0),
            reactions = c('0 -> 2A'),
            ki        = c(2),
            qmax      = 1e3,
            cmax      = 1e4,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_0e2A_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction 0 -> A + B',
    {
        parms <- list(
            species   = c('A', 'B'),
            ci        = c(0, 0),
            reactions = c('0 -> A + B'),
            ki        = c(2),
            qmax      = 1e3,
            cmax      = 1e4,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_0eApB_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction A -> 0',
    {
        parms <- list(
            species   = c('A'),
            ci        = c(1e3),
            reactions = c('A -> 0'),
            ki        = c(1),
            qmax      = 1e3,
            cmax      = 1e5,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_Ae0_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction 2A -> 0',
    {
        parms <- list(
            species   = c('A'),
            ci        = c(1e3),
            reactions = c('2A -> 0'),
            ki        = c(1e-4),
            qmax      = 1e1,
            cmax      = 1e5,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_2Ae0_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the reaction A + B -> 0',
    {
        parms <- list(
            species   = c('A', 'B'),
            ci        = c(1e3, 1e3),
            reactions = c('A + B -> 0'),
            ki        = c(1e-4),
            qmax      = 1e1,
            cmax      = 1e5,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_ApBe0_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the Lotka CRN',
    {
        parms <- list(
            species   = c('X1', 'X2'),
            ci        = c(20e-9, 10e-9),
            reactions = c('X1 + X2 -> 2X2',
                          'X1 -> 2X1',
                          'X2 -> 0'),
            ki        = c(5e5,
                          1/300,
                          1/300),
            qmax      = 1e6,
            cmax      = 10e-6,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 12600, 1)
        )
        behaviors <- run_reaction_4domain(parms, 'data/behavior_lotka_4domain')
        expect_equal(
            behaviors[[1]], behaviors[[2]], tolerance = 1e-1, scale = 1e-11
        )
    }
)

test_that(
    'react_4domain reproduces correctly the behavior of the Consensus CRN',
    {
        parms <- list(
            species   = c('X', 'Y', 'B'),
            ci        = c(0.7 * 80e-9, 0.3 * 80e-9, 0.0),
            reactions = c('X + Y -> 2B',
                          'B + X -> 2X',
                          'B + Y -> 2Y'),
            ki        = c(2e3, 2e3, 2e3),
            qmax      = 1e6,
            cmax      = 10e-6,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 54000, 5)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_consensus_4domain'
        )
        expect_equal(
            behaviors[[1]], behaviors[[2]], tolerance = 1e-1, scale = 1e-11
        )
    }
)

test_that(
    'react_4domain reprduces the behavior of a CRN (called
     behavior_3prod_4domain) with reactions with 3 products.',
    {
        parms <- list(
            species   = c('sA', 'sB', 'sC', 'sD', 'sE', 'sF', 'sG', 'sH'),
            ci        = c( 0,    0,    0,    1e3,  0,    0,    1e3,  0),
            reactions = c('0 -> sA + sB + sC',
                          'sD -> 2sE + sF',
                          '2sG -> 3sH'),
            ki        = c(1e1, 1e-1, 1e-4),
            qmax      = 1e3,
            cmax      = 1e6,
            alpha     = 1,
            beta      = 1,
            t         = seq(0, 100, 1)
        )
        behaviors <- run_reaction_4domain(
            parms,
            'data/behavior_3prod_4domain'
        )
        expect_equal(behaviors[[1]], behaviors[[2]], tolerance = 1e-1)
    }
)
