#import("template_paper.typ"): *

#set math.equation(numbering: "(1)")
#set figure.caption(position: top)

#show quote: set align(center)

#show: paper.with(
  title: [A Simple Commuting Model of Chicago],
  authors: (
    "Connacher Murphy",
  ),
  date: "January 17, 2024",
)

#pad(x: 20%)[
  #quote(
    block: true,
    attribution: [Carl Sandburg]
  )[
    Hog Butcher for the World, \
    Tool Maker, Stacker of Wheat, \
    Player with Railroads and the Nation's Freight Handler; \
    Stormy, husky, brawling, \
    City of the Big Shoulders...

    Come and show me another city with lifted head singing so proud to be alive and coarse and strong and cunning.
  ]
]

#align(center)[
  *Abstract*
]

This repo is intended to demonstrate the basics of conducting economics research with quantitative spatial models. I calibrate a simple quantitative spatial model of Chicago. I conduct various counterfactual exercises.

= Introduction
`In progress.`

// CM: note lack of housing market (and residential choice)
// CM: citations (will include greater detail)

= Model
I begin with a simple model of commuting to demonstrate the basic mechanics of a common form of quantitative spatial model. I then extend this model to include other relevant features of the economy.

== A Simple Model (Model A)
Chicago is comprised of discrete neighborhoods $i, n, k in cal(L)$. Each location $i$ has a mass of $H_i$ of residents.

=== Workers
Each agent inelastically supplies one unit of labor. An agent $omega$ residing in location $i$ and working in location $n$ receives indirect#footnote[I omit the consumer's maximization problem for parsimony.] utility $cal(U)_(n i)$, where
  $
    cal(U)_(i n omega) &= [w_n / kappa_(i n)] epsilon_(i n omega).
  $
$w_n$ is the wage paid in location $n$. $kappa_(i n)$ is a commuting cost of the iceberg form in the units of utility. $epsilon_(i n omega)$ is an idiosyncratic preference shock with a Fréchet distribution. The cumulative distribution function of $epsilon_(i n omega)$ is given by $F(epsilon_(i n omega)) = exp(epsilon_(i n omega)^(-theta))$. $theta$ governs the dispersion of this preference shock.

A worker $omega$ in location $i$ chooses the workplace that maximizes their indirect utility:
  $
    n_(i omega)^(*) eq.def arg max_(n in cal(L)) cal(U)_(i n omega).
  $
Since workers differ only in their draws of ${epsilon_(i n omega)}_(i, n in cal(L))$ of preference shocks, we can drop the $omega$ subscript in what follows. The Fréchet distributed preference shock implies
  $
    pi_(i n) &eq.def PP{n_(i)^(*) = n}
    = [w_n / kappa_(i n)]^(theta) Phi_i^(-1), \
    "where" Phi_i &eq.def sum_(k in cal(L)) [w_k / kappa_(i k)]^(theta).
  $<eqn:commute-probability>
// CM: add a discrete choice citation

=== Firms
A unit mass of firms in each neighborhood produce a numeraire with the technology
  $
    Y_n = A_n L_n^alpha
  $
and pay workers their marginal product.#footnote[Again, I omit details of market structure for parsimony. I do not model trade in goods.] Accordingly, the wage in neighborhood $n$ is given by
  $
    w_n = alpha A_n L_n^(alpha - 1).
  $<eqn:wages>

=== Commuting Equilibrium
For the commuting market to clear, labor demand in location $n$ must equal labor supply to location $n$ across all residential locations $i$:
  $
    L_n = sum_(i in cal(L)) pi_(i n) H_i.
  $<eqn:commuting-clearing>
We can substitute @eqn:commute-probability and @eqn:wages into this expression to obtain the equilibrium characterization:
  $
    underbrace([(alpha A_n) / (w_n)]^(1 / (1 - alpha)), "Labor Demand")
    = underbrace(sum_(i in cal(L)) [w_n / kappa_(i n)]^(theta) Phi_i^(-1) H_i, "Labor Supply").
  $<eqn:commuting-equilibrium>

// CM: add welfare
// CM: existence and uniqueness

=== Counterfactual Equilibria
We consider a baseline equilibrium ${bold(w)^0, bold(pi)^0}$ for parameters ${bold(A)^0, bold(kappa)^0, bold(H)^0}$ and a counterfactual equilibrium ${bold(w)^prime, bold(pi)^prime}$ for parameters ${bold(A)^prime, bold(kappa)^prime, bold(H)^prime}$. We denote proportional changes with hats, e.g.,
  $
    hat(w)_n = (w_n^prime) / w_n^0 arrow.r.double.long w_n^0 hat(w)_n = w_n^prime.
  $
We start by expressing the market clearing condition for the counterfactual equilibrium and then substitute in @eqn:wages:
$
  L_n^0 hat(L)_n &= (sum_(i in cal(L)) (pi_(i n)^0 H_i^0) (hat(pi)_(i n) hat(H)_i)) \
  arrow.r.double.long [(hat(A)_n) / hat(w)_n]^(1 / (1 - alpha)) &= (sum_(i in cal(L)) (pi_(i n)^0 H_i^0) (hat(pi)_(i n) hat(H)_i)) / L_n^0.
$<eqn:exact-hat-clearing>
We can use @eqn:commute-probability to write
  $
    hat(pi)_(i n) &= [hat(w)_n / hat(kappa)_(i n)]^(theta) hat(Phi)_i^(-1), \
    "where"
    hat(Phi)_i &= sum_(k in cal(L)) pi_(i k)^(0) [hat(w)_k / hat(kappa)_(i k)]^(theta).
  $<eqn:exact-hat-pi>
The substantive piece of this expression is $hat(Phi)_i$. We derive it below:
  $
    hat(Phi)_i
    =
    (sum_(k in cal(L)) text(
      fill: #red,
      [w_k^0 / kappa_(i k)^0]^(theta)
    )
      [hat(w)_k / hat(kappa)_(i k)]^(theta)) /
    (text(
      fill: #red,
      sum_(l in cal(L)) [w_l^0 / kappa_(i l)^0]^(theta)
    ))
    = sum_(k in cal(L)) text(
      fill: #red,
      pi_(i k)^(0)
    )
    [hat(w)_k / hat(kappa)_(i k)]^(theta),
  $
where we have used @eqn:commute-probability to substitute in for $pi_(i k)^(0)$. We now combine @eqn:exact-hat-clearing and @eqn:exact-hat-pi to obtain
  $
    [(hat(A)_n) / hat(w)_n]^(1 / (1 - alpha))
    &= [
      sum_(i in cal(L))
      (pi_(i n)^0 H_i^0 hat(H)_i [hat(w)_n / hat(kappa)_(i n)]^(theta)) /
      (sum_(k in cal(L)) pi_(i k)^(0) [hat(w)_k / hat(kappa)_(i k)]^(theta))
    ] 1 / L_n^0.
  $<eqn:exact-hat-combined>
What does this representation get us? If we express a counterfactual as a set of proportional changes to the parameter values ${hat(bold(A)), hat(bold(kappa)), hat(bold(H))}$, then we only need data on initial commuting probabilities $bold(pi)^0$, workplace population $bold(L)^0$, and residential population $bold(H)^0$ to solve for the proportional changes in wages $hat(bold(w))$ (using @eqn:exact-hat-combined) and commuting probabilities $hat(bold(pi))$ (using @eqn:exact-hat-pi).

Inspired by this representation, we define
  $
    cal(Z)_(n)(tilde(bold(w)))
    eq.def
    [(hat(A)_n) / tilde(w)_n]^(1 / (1 - alpha))
    - [
      sum_(i in cal(L))
      (pi_(i n)^0 H_i^0 hat(H)_i [tilde(w)_n / hat(kappa)_(i n)]^(theta)) /
      (sum_(k in cal(L)) pi_(i k)^(0) [tilde(w)_k / hat(kappa)_(i k)]^(theta))
    ] 1 / L_n^0.
  $

// CM: add the algorithm here

// CM: add a different index above and below

// To solve this on the computer, define

// Let $bold(cal(Z))(hat(bold(w))) eq.def {cal(Z)_(n)(hat(bold(w)))}_(n in cal(L))$. Start with a guess of $hat(bold(w)) = bold(1)$ and iterate. For each step, we update the wage vector with...

// // We use @eqn:commuting-equilibrium to build excess demand for labor in each location $n$:
// // $
// //   cal(Z)_(n)(w_n) eq.def underbrace([(alpha A_n) / (w_n)]^(1 / (1 - alpha)), "Labor Demand")
// //   - underbrace(sum_(i in cal(L)) B_n [w_n / d_(n i)]^(theta) Phi_i^(-1) H_i, "Labor Supply")
// // $

== A Richer Model (Model B)
`In progress.`

= Data and Calibration
`In progress.`

= Counterfactual Exercises
`In progress.`