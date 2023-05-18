module SpeedyWeather

# STRUCTURE
using DocStringExtensions

# NUMERICS
import Random
import FastGaussQuadrature
import LinearAlgebra: LinearAlgebra, Diagonal

# GPU, PARALLEL
import Base.Threads: Threads, @threads
import FLoops: FLoops, @floop
import KernelAbstractions
import CUDA
import CUDAKernels
import Adapt: Adapt, adapt, adapt_structure

# INPUT OUTPUT
import TOML
import Dates: Dates, DateTime
import Printf: @sprintf
import NetCDF: NetCDF, NcFile, NcDim, NcVar
import JLD2: jldopen
import CodecZlib
import BitInformation: round, round!
import UnicodePlots
import ProgressMeter

# EXPORT MONOLITHIC INTERFACE TO SPEEDY
export  run_speedy,
        run_speedy!,
        initialize_speedy

export  SigmaCoordinates,
        SigmaPressureCoordinates

# EXPORT MODELS
export  Barotropic,
        ShallowWater,
        PrimitiveEquation,
        PrimitiveDryCore,
        PrimitiveWetCore

# EXPORT GRIDS
export  SpectralGrid,
        Geometry

export  LowerTriangularMatrix,
        FullClenshawGrid,
        FullGaussianGrid,
        FullHEALPixGrid,
        FullOctaHEALPixGrid,
        OctahedralGaussianGrid,
        OctahedralClenshawGrid,
        HEALPixGrid,
        OctaHEALPixGrid

export  LeapfrogSemiImplicit

# EXPORT OROGRAPHIES
export  NoOrography,
        EarthOrography,
        ZonalRidge

export  HyperDiffusion

# EXPORT INITIAL CONDITIONS
export  StartFromFile,
        StartFromRest,
        ZonalJet,
        ZonalWind,
        StartWithVorticity

# EXPORT TEMPERATURE RELAXATION SCHEMES
export  NoTemperatureRelaxation,
        HeldSuarez,
        JablonowskiRelaxation

# EXPORT BOUNDARY LAYER SCHEMES
export  NoBoundaryLayer,
        LinearDrag

# EXPORT VERTICAL DIFFUSION
export  NoVerticalDiffusion,
        VerticalLaplacian

# EXPORT STRUCTS
export  DynamicsConstants,
        SpectralTransform,
        Boundaries,
        PrognosticVariables,
        DiagnosticVariables,
        ColumnVariables

# EXPORT SPECTRAL FUNCTIONS
export  SpectralTransform,
        spectral,
        gridded,
        spectral_truncation
        
include("utility_functions.jl")

# LowerTriangularMatrices for spherical harmonics
export LowerTriangularMatrices
include("LowerTriangularMatrices/LowerTriangularMatrices.jl")
using .LowerTriangularMatrices

# RingGrids
export RingGrids
include("RingGrids/RingGrids.jl")
using .RingGrids

# SpeedyTransforms
export SpeedyTransforms
include("SpeedyTransforms/SpeedyTransforms.jl")
using .SpeedyTransforms
    
include("gpu.jl")                               # defines utility for GPU / KernelAbstractions

include("abstract_types.jl")
include("dynamics/vertical_coordinates.jl")
include("dynamics/spectral_grid.jl")
include("dynamics/planets.jl")
include("dynamics/atmospheres.jl")
include("dynamics/constants.jl")
include("dynamics/prognostic_variables.jl")
include("physics/define_column.jl")             # define ColumnVariables
include("dynamics/diagnostic_variables.jl")
include("dynamics/time_integration.jl")
include("dynamics/models.jl")

# # SOME DEFINITIONS FIRST
# include("physics/constants.jl")                 # defines ParameterizationConstants

# # DYNAMICS
# include("dynamics/orography.jl")                # defines Orography
# include("dynamics/define_diffusion.jl")         # defines HorizontalDiffusion
# include("dynamics/define_implicit.jl")          # defines ImplicitShallowWater, ImplicitPrimitiveEq     # defines GenLogisticCoefs
# include("dynamics/planets.jl")                  # defines Earth
# include("dynamics/models.jl")                   # defines ModelSetups
# include("dynamics/initial_conditions.jl")
# include("dynamics/scaling.jl")
# include("dynamics/geopotential.jl")
# include("dynamics/tendencies_dynamics.jl")
# include("dynamics/tendencies.jl")
# include("dynamics/implicit.jl")
# include("dynamics/diffusion.jl")

# # PHYSICS
# include("physics/column_variables.jl")
# include("physics/thermodynamics.jl")
# include("physics/tendencies.jl")
# include("physics/convection.jl")
# include("physics/large_scale_condensation.jl")
# include("physics/longwave_radiation.jl")
# include("physics/shortwave_radiation.jl")
# include("physics/boundary_layer.jl")
# include("physics/temperature_relaxation.jl")
# include("physics/vertical_diffusion.jl")

# # OUTPUT
# include("output/output.jl")                     # defines Output
# include("output/feedback.jl")                   # defines Feedback
# include("output/pretty_printing.jl")

# # INTERFACE
# include("run_speedy.jl")
end