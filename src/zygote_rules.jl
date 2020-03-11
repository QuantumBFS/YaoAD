using ZygoteRules
using YaoBlocks
using YaoArrayRegister
using YaoBlocks.AD

@adjoint function YaoBlocks.expect(op::AbstractBlock, reg::ArrayReg, circuit::AbstractBlock)
    out = copy(reg) |> circuit
    ext = expect(op, out)

    function expect_pullback(Δ)
        ∇out = copy(out) |> op
        (in, ∇in), ∇ps = apply_back((out, ∇out), circuit)
    
        return nothing, ∇in, @. ∇ps * 2 * Δ
    end

    return ext, expect_pullback
end

@adjoint function apply!(reg::ArrayReg, block::AbstractBlock)
    out = apply!(reg, block)
    out, function (outδ)
        (in, inδ), paramsδ = apply_back((out, outδ), block)
        return (inδ, paramsδ)
    end
end

@adjoint function Matrix(block::AbstractBlock)
    out = Matrix(block)
    out, function (outδ)
        paramsδ = mat_back(block, outδ)
        return (paramsδ,)
    end
end

@adjoint function ArrayReg{B}(raw::AbstractArray) where B
    ArrayReg{B}(raw), adjy->(reshape(adjy.state, size(raw)),)
end

@adjoint function ArrayReg{B}(raw::ArrayReg) where B
    ArrayReg{B}(raw), adjy->(adjy,)
end

@adjoint function ArrayReg(raw::AbstractArray)
    ArrayReg(raw), adjy->(reshape(adjy.state, size(raw)),)
end

@adjoint function copy(reg::ArrayReg) where B
    copy(reg), adjy->(adjy,)
end

@adjoint state(reg::ArrayReg) = state(reg), adjy->(ArrayReg(adjy),)
@adjoint statevec(reg::ArrayReg) = statevec(reg), adjy->(ArrayReg(adjy),)
@adjoint state(reg::AdjointArrayReg) = state(reg), adjy->(ArrayReg(adjy')',)
@adjoint statevec(reg::AdjointArrayReg) = statevec(reg), adjy->(ArrayReg(adjy')',)
@adjoint parent(reg::AdjointArrayReg) = parent(reg), adjy->(adjy',)
@adjoint Base.adjoint(reg::ArrayReg) = Base.adjoint(reg), adjy->(parent(adjy),)