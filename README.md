# ProjectEulerDownload

Makes it easy to download a problem from [Project Euler](https://projecteuler.net/) into a nice folder structure to solve them one by one.

## Installation

This is not a registered package so you need to add it with:

```
] add https://github.com/Wikunia/ProjectEulerDownload.jl
```

## Usage

```
using ProjectEulerDownload
# to have a shorter notation
const PED = ProjectEulerDownload

# once =>
PED.configure("PATH TO YOUR PROJECT EULER ROOT DIRECTORY")

# then
PED.download(1)
```

will create a folder `001_Multiples_of_3_and_5` in your specified directory with three files:

#### README.md

Includes the problem description and a link to the actual problem.

#### solution.jl

Just an empty file where you can define your functions.

#### runtests.jl

Includes:

```
using Test

include("solution.jl")

@testset "example" begin
	@test
end
```

here you can define your own test sets which can help you to solve the problem.

## Disclaimer

I have absolutely nothing to do with ProjectEuler. I just like to solve their problems ;)
