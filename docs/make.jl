using Documenter, DailyTreasuryYieldCurve

makedocs(
    modules = [DailyTreasuryYieldCurve],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "Tyler Beason",
    sitename = "DailyTreasuryYieldCurve.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/tbeason/DailyTreasuryYieldCurve.jl.git",
    push_preview = true
)
