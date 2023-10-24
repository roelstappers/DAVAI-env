using Documenter


pages = [
    "Getting Started" => [
        "Setup" => "forge-setup.md"
        "Prepare branch" => "forge-branch.md"
    ],
    "HPC Platforms" => [
       "Belenos" => "belenos.md",
       "Atos" => "atos_bologna.md"
    ],
    "User Guide" => "userguide/user-guide.md" 
]


format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true", 
                    ) 

makedocs(
    sitename = "Davai",
    format = format,
    pages = pages
)

deploydocs(
    repo = "github.com/ACCORD-NWP/DAVAI-env.git",
    devbranch = "master",   
    devurl = "master",
)
