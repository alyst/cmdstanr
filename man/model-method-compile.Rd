% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/model.R
\name{model-method-compile}
\alias{model-method-compile}
\alias{compile}
\title{Compile a Stan program}
\usage{
compile(
  quiet = TRUE,
  dir = NULL,
  pedantic = FALSE,
  include_paths = NULL,
  cpp_options = list(),
  stanc_options = list(),
  force_recompile = FALSE,
  threads = FALSE
)
}
\arguments{
\item{quiet}{(logical) Should the verbose output from CmdStan during
compilation be suppressed? The default is \code{TRUE}, but if you encounter an
error we recommend trying again with \code{quiet=FALSE} to see more of the
output.}

\item{dir}{(string) The path to the directory in which to store the CmdStan
executable (or \code{.hpp} file if using \verb{$save_hpp_file()}). The default is the
same location as the Stan program.}

\item{pedantic}{(logical) Should pedantic mode be turned on? The default is
\code{FALSE}. Pedantic mode attempts to warn you about potential issues in your
Stan program beyond syntax errors. For details see the \href{https://mc-stan.org/docs/reference-manual/pedantic-mode.html}{\emph{Pedantic mode} chapter} in
the Stan Reference Manual. \strong{Note:} to do a pedantic check for a model
that is already compiled use the
\code{\link[=model-method-check_syntax]{$check_syntax()}} method instead.}

\item{include_paths}{(character vector) Paths to directories where Stan
should look for files specified in \verb{#include} directives in the Stan
program.}

\item{cpp_options}{(list) Any makefile options to be used when compiling the
model (\code{STAN_THREADS}, \code{STAN_MPI}, \code{STAN_OPENCL}, etc.). Anything you would
otherwise write in the \code{make/local} file.}

\item{stanc_options}{(list) Any Stan-to-C++ transpiler options to be used
when compiling the model. See the \strong{Examples} section below as well as the
\code{stanc} chapter of the CmdStan Guide for more details on available options:
https://mc-stan.org/docs/cmdstan-guide/stanc.html.}

\item{force_recompile}{(logical) Should the model be recompiled even if was
not modified since last compiled. The default is \code{FALSE}.}

\item{threads}{Deprecated and will be removed in a future release. Please
turn on threading via \code{cpp_options = list(stan_threads = TRUE)} instead.}
}
\value{
The \verb{$compile()} method is called for its side effect of creating the
executable and adding its path to the \code{\link{CmdStanModel}} object, but it also
returns the \code{\link{CmdStanModel}} object invisibly.

After compilation, the \verb{$exe_file()}, \verb{$hpp_file()}, and \verb{$save_hpp_file()}
methods can be used and return file paths.
}
\description{
The \verb{$compile()} method of a \code{\link{CmdStanModel}} object checks the
syntax of the Stan program, translates the program to C++, and creates a
compiled executable. To just check the syntax of a Stan program without
compiling it use the \code{\link[=model-method-check_syntax]{$check_syntax()}} method
instead.

In most cases the user does not need to explicitly call the \verb{$compile()}
method as compilation will occur when calling \code{\link[=cmdstan_model]{cmdstan_model()}}. However it
is possible to set \code{compile=FALSE} in the call to \code{cmdstan_model()} and
subsequently call the \verb{$compile()} method directly.

After compilation, the paths to the executable and the \code{.hpp} file
containing the generated C++ code are available via the \verb{$exe_file()} and
\verb{$hpp_file()} methods. The default is to create the executable in the same
directory as the Stan program and to write the generated C++ code in a
temporary directory. To save the C++ code to a non-temporary location use
\verb{$save_hpp_file(dir)}.
}
\examples{
\dontrun{
file <- file.path(cmdstan_path(), "examples/bernoulli/bernoulli.stan")

# by default compilation happens when cmdstan_model() is called.
# to delay compilation until calling the $compile() method set compile=FALSE
mod <- cmdstan_model(file, compile = FALSE)
mod$compile()
mod$exe_file()

# turn on threading support (for using functions that support within-chain parallelization)
mod$compile(force_recompile = TRUE, cpp_options = list(stan_threads = TRUE))
mod$exe_file()

# turn on pedantic mode (new in Stan v2.24)
file_pedantic <- write_stan_file("
parameters {
  real sigma;  // pedantic mode will warn about missing <lower=0>
}
model {
  sigma ~ exponential(1);
}
")
mod <- cmdstan_model(file_pedantic, pedantic = TRUE)

}

}
\seealso{
The \code{\link[=model-method-check_syntax]{$check_syntax()}} method to check
Stan syntax or enable pedantic model without compiling.

The CmdStanR website
(\href{https://mc-stan.org/cmdstanr/}{mc-stan.org/cmdstanr}) for online
documentation and tutorials.

The Stan and CmdStan documentation:
\itemize{
\item Stan documentation: \href{https://mc-stan.org/users/documentation/}{mc-stan.org/users/documentation}
\item CmdStan User’s Guide: \href{https://mc-stan.org/docs/cmdstan-guide/}{mc-stan.org/docs/cmdstan-guide}
}

Other CmdStanModel methods: 
\code{\link{model-method-check_syntax}},
\code{\link{model-method-diagnose}},
\code{\link{model-method-generate-quantities}},
\code{\link{model-method-optimize}},
\code{\link{model-method-sample_mpi}},
\code{\link{model-method-sample}},
\code{\link{model-method-variables}},
\code{\link{model-method-variational}}
}
\concept{CmdStanModel methods}
