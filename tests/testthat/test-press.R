context("test-press.R")

describe("press", {

  it("Adds parameters to output", {
    res <- press(
      x = 1,
      mark(1, max_iterations = 10)
    )
    expect_equal(colnames(res), c("expression", "x", summary_cols, data_cols))
    expect_equal(nrow(res), 1)

    res2 <- press(
      x = 1:3,
      mark(1, max_iterations = 10)
    )
    expect_equal(colnames(res2), c("expression", "x", summary_cols, data_cols))
    expect_equal(nrow(res2), 3)
  })
  #it("Outputs status message when running each parameter", {
    #expect_message(regexp = "Running benchmark with:\n.*x",
      #res <- mark(1, parameters = list(x = 1), max_iterations = 10))
    #expect_equal(colnames(res), c("expression", "x", summary_cols, data_cols))
    #expect_equal(nrow(res), 1)

    #res2 <- mark(1, parameters = list(x = 1:3), max_iterations = 10)
    #expect_equal(colnames(res2), c("expression", "x", summary_cols, data_cols))
    #expect_equal(nrow(res2), 3)
  #})

  it("expands the grid if has named parameters", {
    res <- press(
      x = c(1, 2),
      y = c(1, 3),
      mark(list(x, y), max_iterations = 10)
    )
    expect_equal(res$x, c(1, 2, 1, 2))
    expect_equal(res$y, c(1, 1, 3, 3))
    expect_equal(res$result[[1]], list(1, 1))
    expect_equal(res$result[[2]], list(2, 1))
    expect_equal(res$result[[3]], list(1, 3))
    expect_equal(res$result[[4]], list(2, 3))
  })

  it("takes values as-is if given in .grid", {
    res <- press(
      .grid = data.frame(x = c(1, 2), y = c(1,3)),
      mark(list(x, y), max_iterations = 10)
    )
    expect_equal(res$x, c(1, 2))
    expect_equal(res$y, c(1, 3))
    expect_equal(res$result[[1]], list(1, 1))
    expect_equal(res$result[[2]], list(2, 3))
  })

  it("runs `setup` with the parameters evaluated", {
    x <- 1
    res <- press(
      y = 2,
      {
        x <- y
        mark(x)
      })
    expect_equal(res$result[[1]], 2)
  })
})
