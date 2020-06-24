\name{NEWS}
\title{News for Package \pkg{sets}}

\section{Changes in version 1.0-18}{
  \itemize{
    \item Do not export \code{as.list.function()} any more
  }
}

\section{Changes in version 1.0-17}{
  \itemize{
    \item add \code{lengths} method
    \item the extract operator (\code{[[}) now returns \code{NULL} if
    the requested element can not be found instead of throwing a cryptical
    error message
    \item some small internal optimizations
  }
}

\section{Changes in version 1.0-16}{
  \itemize{
    \item no user-level changes
  }
}

\section{Changes in version 1.0-15}{
  \itemize{
    \item add import statements for functions in recommended packages to
    \file{NAMESPACE}
  }
}

\section{Changes in version 1.0-14}{
  \itemize{
    \item internal fix because \code{nchar(NA)} now returns \code{NA}
  }
}

\section{Changes in version 1.0-13}{
  \itemize{
    \item Rd improvements
  }
}

\section{Changes in version 1.0-12}{
  \itemize{
    \item small fix in \code{LABELS()} (when called with \code{NULL})
  }
}

\section{Changes in version 1.0-11}{
  \itemize{
    \item Author/Maintainer info removed from DESCRIPTION
  }
}

\section{Changes in version 1.0-10}{
  \itemize{
    \item The \code{length()} methods for [cg]sets are no 
    longer aliases for \code{gset_cardinality()},
    but for \code{set_cardinality()} (i.e., give the number of
    elements in the [cg]set).
    This change has been made since \code{length()}
    methods are expected to yield integer values only.
  }
}

\section{Changes in version 1.0-9}{
  \itemize{
    \item small bug fix in \code{fuzzy_two_normals()}
  }
}

\section{Changes in version 1.0-8}{
  \itemize{
    \item Package news converted to Rd format.
  }
}
\section{Changes in version 1.0-7}{
  \itemize{
    \item small fix in interval code
  }
}
\section{Changes in version 1.0-6}{
  \itemize{
    \item small fix in \code{all.equal()} method
  }
}
\section{Changes in version 1.0-5}{
  \itemize{
    \item bug fix in \code{all.equal()} method
    \item overloaded set operators will now work for operands of mixed set types
  }
}
\section{Changes in version 1.0-4}{
  \itemize{
    \item \code{as.list.interval()} now returns a list of intervals instead of
      just applying \code{unclass()}
  }
}
\section{Changes in version 1.0-3}{
  \itemize{
    \item small bug fixes
  }
}
\section{Changes in version 1.0-2}{
  \itemize{
    \item small bug fixes
  }
}
\section{Changes in version 1.0-1}{
  \itemize{
    \item interval class for possibly infinite numeric intervals added.
    \item fuzzy rules now accept the use of brackets in the expressions.
    \item Missing memberships are now supported.
  }
}
\section{Changes in version 1.0}{
  \itemize{
    \item JSS article as vignette added.
    \item \code{fuzzy_pi4()} generator added.
    \item [gc]set_memberships extended to allow for filter elements and
      to work with tuples.
  }
}
\section{Changes in version 0.7}{
  \itemize{
    \item L1 and L2 dissimilarities for fuzzy multisets added.
    \item \code{fuzzy_pi()} generator added
    \item (fuzzy) multisets are now \eqn{n}-bounded (where \eqn{n} is
      the maximal multiplicity). 
      This now allows consistent complement-building.
    \item nu-cuts added (filters elements according to multiplicity).
  }
}
\section{Changes in version 0.6}{
  \itemize{
    \item fuzzy inference framework added
    \item converters for matrices added
  }
}
\section{Changes in version 0.5}{
  \itemize{
    \item bug fixes in ordering function and \code{as.character.cset()}
  }
}
\section{Changes in version 0.4}{
  \itemize{
    \item fuzzy function generators added
    \item extended plotting for fuzzy sets added
    \item several functions for memberships transformation added
    \item performance of matching operator improved
    \item optional universes for gsets added
  }
}
\section{Changes in version 0.3}{
  \itemize{
    \item support for customizable sets (cset) added
  }
}
\section{Changes in version 0.2-1}{
  \itemize{
    \item \code{set_options()} added
  }
}
\section{Changes in version 0.2}{
  \itemize{
    \item A \emph{lot} of bug fixes
    \item closure and reduction of sets added
  }
}
\section{Changes in version 0.1}{
  \itemize{
    \item Initial release, implementing data structures and methods for
      ordinary sets, generalized sets (fuzzy sets, multisets, fuzzy
      multisets) as well as support for fuzzy logic.
  }
}
