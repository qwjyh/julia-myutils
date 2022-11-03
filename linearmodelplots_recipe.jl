using DataFrames, GLM


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
    if interval === nothing
        x -> begin
            input_term = reg.mf.f.rhs.terms[2] |> Symbol
            input_df = DataFrame(input_term => [x])
            predict(reg, input_df)[1]
        end
    else
        x -> begin
            input_term = reg.mf.f.rhs.terms[2] |> Symbol
            input_df = DataFrame(input_term => [x])
            result_nt = predict(reg, input_df; interval = interval, level = level)[1, :] |> NamedTuple
#            nt_keys = keys(result_nt)
#            @eval ($(nt_keys[1]) = result_nt[1], interval = ($(nt_keys[2]) = result_nt[2], $(nt_keys[3]) = result_nt[3]))
            (prediction = result_nt[1], interval = (lower = result_nt[1] - result_nt[2], upper = result_nt[3] - result_nt[1]))
        end
    end
end

