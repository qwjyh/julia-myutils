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


"""
returns predictor function
interval = nothing(default)
  --> which returns prediction::AbstractFloat
interval = :confidence or :prediction
  --> which returns Tuple of (prediction, lower, upper)
"""
function get_prediction_function(
        reg::StatsModels.TableRegressionModel; 
        interval::Union{Symbol,Nothing} = nothing,
        level::Real = 0.95
    )
    if interval == nothing
        x -> begin
            input_term = reg.mf.f.rhs.terms[2] |> Symbol
            input_df = DataFrame(input_term => [x])
            predict(reg, input_df)[1]
        end
    else
        x -> begin
            input_term = reg.mf.f.rhs.terms[2] |> Symbol
            input_df = DataFrame(input_term => [x])
            predict(reg, input_df, interval = interval, level = level)[1, :] |> Tuple
        end
    end
end

