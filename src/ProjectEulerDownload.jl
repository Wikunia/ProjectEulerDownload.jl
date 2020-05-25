module ProjectEulerDownload

using JSON
using Cascadia
using DataFrames
using Gumbo
using HTTP

const PED = ProjectEulerDownload

function configure(euler_dir::String)
    dir = pkgdir(PED)
    d = Dict("root" => euler_dir)
    write(joinpath(dir, "config.json"), JSON.json(d))
end

function download(problem_id::Int)
    pdir = pkgdir(PED)
    config_path = joinpath(pdir, "config.json")
    if !isfile(config_path) 
        error("Please run PED.configure(\"Path to root directory\") first") 
        return
    end
    root_dir = JSON.parsefile(config_path)["root"]
    cd(root_dir)

    url = "https://projecteuler.net/problem=$problem_id";
    res = HTTP.get(url);
    body = String(res.body);
    html = parsehtml(body);
    
    title = text(eachmatch(sel"h2", html.root)[1][1]);
    folder_title = replace(title, " "=> "_")
    lid = lpad(problem_id, 3, '0')
    folder = "$(lid)_$folder_title"
    # create the new folder and change to there
    mkdir(folder)
    cd(folder)

    # CREATE SEVERAL FILES
    # README.md
    problem_content = eachmatch(sel".problem_content", html.root)[1]
    str_content = string(problem_content)
    str_content = replace(str_content, "</p>" =>"\n")
    str_content = replace(str_content, r"<dfn(>|.*?>)(?<text>.*?)</dfn>" => s"**\g<text>**")
    str_content = replace(str_content, r"<(?<tag>[/]?(sup|sub))>" => s"<_\g<tag>>")
    str_content = replace(str_content, r"<[^_].*?>" => "")
    str_content = replace(str_content, r"<_(?<tag>.*?)>" => s"<\g<tag>>")

    readme = "# $title\n$str_content\n\nSource: [Project Euler #$problem_id]($url)"
    write("README.md", readme)
    println("Checkout the readme!")
    println(joinpath(pwd(), "README.md"))

    # solution.jl
    write("solution.jl", "")

    # runtests.jl
    test_file = "using Test\n\ninclude(\"solution.jl\")\n\n"
    test_file *= "@testset \"example\" begin\n"
    test_file *= "\t@test\n"
    test_file *= "end"
    write("runtests.jl", test_file);

    println("Happy coding!")
end

end
