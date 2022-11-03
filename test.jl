using Plots, DataFrames, GLM

# prepare example values
x = [i for i in 1:10]
y = [-0.1 + 2.0 * i + 18 * rand() for i in 1:10]
df = DataFrame("x" => x, "y" => y)

# test plot
plot(
     df.x,
     df.y,
     seriestype = :scatter,
)

# linear regression
reg = lm(@formula(y ~ x), df)

include("linearmodelplots_recipe.jl")

plot!(
      df.x,
      (x -> get_prediction_function(reg, interval = :prediction)(x).prediction).(df.x),
      ribbon = (
          (x -> get_prediction_function(reg, interval = :confidence)(x).interval.upper).(1:10),
          (x -> get_prediction_function(reg, interval = :confidence)(x).interval.lower).(1:10)
      )
)

