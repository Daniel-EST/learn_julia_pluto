### A Pluto.jl notebook ###
# v0.11.12

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 3a5ce490-16ff-11eb-2151-bf0fba7ce9b7
using Distributions

# ╔═╡ 5239bfc0-16ff-11eb-3717-219f8a3d7702
using Plots

# ╔═╡ dbd0b470-1707-11eb-300c-21e3c352048b
md"""# Metropolis-Hastings Algorithm"""

# ╔═╡ 5565f972-16ff-11eb-0f20-532c5c47add1
function metropolis_hastings_binom(N::Int, xo::Int, theta::Real)
	x = [xo]
	for i in 2:10000
		y = sample(0:N)
		prev = x[i - 1] 
		
		numerator = pdf(Binomial(N, theta), y)
		denominator = pdf(Binomial(N, theta), prev)
		
		ratio = numerator/denominator
		if ratio < 1
			temp = ratio > rand() ? y : prev
			append!(x, temp)
		else
			append!(x, y)
		end
	end
	
	# Graphs
	keys = 0:N
	count = mapreduce(x -> x .== keys, +, x)
	count = count/sum(count)
	if N < 15
		simulation = bar(keys, count, 
			xticks = 0:N, 
			color = "lightgreen", 
			yaxis = false)
		theorical = bar(keys, pdf(Binomial(N, theta)), xticks = 0:N)
	else
		simulation = bar(keys, count, color = "lightgreen", yaxis = false)
		theorical = bar(keys, pdf(Binomial(N, theta)))
	end
	plot(theorical, simulation, 
		layout = 2,
		label = ["" ""],
		title = ["Theorical" "Simulation"], 
		link = :y
	)
end

# ╔═╡ eeb33460-1701-11eb-20f8-09f89a057727
md"""
	N: $(@bind N html"<select><option value='5'>5</option><option value='10'>10</option><option value='50'>50</option><option value='100'>100</option></select>")

	θ: $(@bind theta html"<select><option value='0.5'>1/2</option><option value='0.333333333'>1/3</option><option value='0.25'>1/4</option><option value='0.2'>1/5</option><option value='0.1'>1/10</option></select>")"""

# ╔═╡ 5a8613e0-16ff-11eb-0a5b-0b5dd6e779ab
metropolis_hastings_binom(parse(Int64, N), 1, parse(Float64, theta))

# ╔═╡ Cell order:
# ╟─dbd0b470-1707-11eb-300c-21e3c352048b
# ╠═3a5ce490-16ff-11eb-2151-bf0fba7ce9b7
# ╠═5239bfc0-16ff-11eb-3717-219f8a3d7702
# ╠═5565f972-16ff-11eb-0f20-532c5c47add1
# ╟─eeb33460-1701-11eb-20f8-09f89a057727
# ╟─5a8613e0-16ff-11eb-0a5b-0b5dd6e779ab
