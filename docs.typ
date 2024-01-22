#import("typst/template_paper.typ"): *
#import("typst/common_commands.typ"): *

#set math.equation(numbering: "(1)")
#set figure.caption(position: top)

#show raw.where(block: true): block.with(
  fill: luma(250),
  stroke: luma(100) + 1pt,
  inset: 6pt,
  radius: 4pt,
)

#show quote: set align(center)

#show: paper.with(
  title: [Quantitative Spatial Models in Economics: A Simple Commuting Model of Chicago],
  authors: (
    "Connacher Murphy",
  ),
  date: "January 22, 2024",
)

#align(center)[
  ```
  This is a live document and subject to change.
  ```
]

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

This repo is intended to demonstrate the basics of conducting economics research with quantitative spatial models. I derive and calibrate a simple quantitative spatial model of Chicago and conduct two counterfactual exercises. I then repeat this process for a richer model and compare the results.

= Introduction
```
In progress.
```

// CM: note lack of housing market (and residential choice)
// CM: citations (will include greater detail)

= Model
I begin with a simple model of commuting to demonstrate the basic mechanics of a common form of quantitative spatial model. I then extend this model to include other relevant features of the economy.

== A Simple Model (Model A)
Chicago is comprised of discrete neighborhoods $i, n, k, l in cal(L)$. Each location $i$ has a fixed mass $R_i$ of residents.

=== Workers
Each agent inelastically supplies one unit of labor. An agent $omega$ residing in location $i$ and working in location $n$ receives indirect#footnote[I omit the subproblem of utility maximization given location choice for parsimony. Model B will explicitly discuss this subproblem, which nests the subproblem of utility maximization in this model.] utility $cal(U)_(n i)$, where
  $
    cal(U)_(i n omega) &= (w_n / kappa_(i n)) b_(i n omega).
  $
$w_n$ is the wage paid in location $n$. $kappa_(i n)$ is a commuting cost of the iceberg form in the units of utility. $b_(i n omega)$ is an idiosyncratic preference shock with a Fréchet distribution. The cumulative distribution function of $b_(i n omega)$ is given by $F_(i n)(b_(i n omega)) = exp(b_(i n omega)^(-theta))$. $theta$ governs the dispersion of this preference shock.

A worker $omega$ in location $i$ chooses the workplace that maximizes their indirect utility:
  $
    n_(i omega)^(*) eq.def arg max_(n in cal(L)) cal(U)_(i n omega).
  $
Since workers differ only in their draws of ${b_(i n omega)}_(i, n in cal(L))$ of preference shocks, we can drop the $omega$ subscript in what follows. The Fréchet-distributed preference shock implies
  $
    pi_(i n | i) &eq.def PP{n_(i)^(*) = n}
    &= phi_(i n) Phi_i^(-1), \
    "where"quad phi_(i n)
    &eq.def (w_n / kappa_(i n))^(theta) \
    "and" Phi_i
    &eq.def sum_(k in cal(L)) phi_(i k).
  $<eqn:commute-probability>

```
Pending a citation on discrete choice magic.
```
// CM: add a discrete choice citation

// CM: change all equation references to mX- standard

=== Firms
```
This section currently omits some details concerning market structure. I will add a discussion for the sake of completeness, but the equilibrium characterization will not change.
```

A unit mass of firms in each neighborhood produce a freely traded final good with the technology
  $
    Y_n = A_n L_n^beta
  $
and pay workers their marginal product.#footnote[Again, I omit details of market structure for parsimony. I do not explicitly model trade in goods.] The price of the final good is $1$. Accordingly, the wage and labor demand in neighborhood $n$ are given by
  $
    w_n &= beta A_n L_n^(beta - 1) \
    arrow.r.double.long
    L_n &= ((beta A_n) / w_n)^(1 / (1 - beta)).
  $<eqn:mA-wages>

=== Commuting Equilibrium
For the commuting market to clear, labor demand in location $n$ must equal labor supply to location $n$ across all residential locations $i$:
  $
    L_n = sum_(i in cal(L)) pi_(i n | i) R_i.
  $<eqn:commuting-clearing>
We can substitute @eqn:commute-probability and @eqn:mA-wages into this expression to obtain an equilibrium characterization:
  $
    underbrace(((beta A_n) / w_n)^(1 / (1 - beta)), "Labor Demand")
    = underbrace(sum_(i in cal(L)) phi_(i n) Phi_i^(-1) R_i, "Labor Supply").
  $<eqn:commuting-equilibrium>

```
This section does not discuss the existence and uniqueness of the equilibrium, nor does it discuss welfare. I will add sections on these topics in the future.
```

// CM: add welfare
// CM: existence and uniqueness

=== Counterfactual Equilibria
I will denote the vector-collection of a variable $x_i$ over all locations with boldface: ${x_i}_(i in cal(L)) eq.def bold(x)$.
We consider a baseline equilibrium ${bold(w)^0, bold(pi)^0}$ for parameters ${bold(A)^0, bold(kappa)^0, bold(R)^0}$ and a counterfactual equilibrium ${bold(w)^prime, bold(pi)^prime}$ for parameters ${bold(A)^prime, bold(kappa)^prime, bold(R)^prime}$. We denote proportional changes with hats, e.g.,
  $
    hat(w)_n = (w_n^prime) / w_n^0 arrow.r.double.long w_n^0 hat(w)_n = w_n^prime.
  $
This representation leads us to "exact hat algebra," a popular method to model and summarize counterfactual equilibria. We start by expressing the market clearing condition for the counterfactual equilibrium and then substitute in @eqn:mA-wages:
$
  L_n^0 hat(L)_n &= (sum_(i in cal(L)) (pi_(i n)^0 R_i^0) (hat(pi)_(i n) hat(R)_i)) \
  arrow.r.double.long ((hat(A)_n) / hat(w)_n)^(1 / (1 - beta)) &= (sum_(i in cal(L)) (pi_(i n)^0 R_i^0) (hat(pi)_(i n) hat(R)_i)) / L_n^0.
$<eqn:exact-hat-clearing>
We can use @eqn:commute-probability to write
  $
    hat(pi)_(i n | i)
    &= hat(phi)_(i n) hat(Phi)_i^(-1), \
    "where"quad hat(phi)_(i n)
    &eq.def (hat(w)_n / hat(kappa)_(i n))^(theta) \
    "and" hat(Phi)_i
    &eq.def sum_(k in cal(L)) pi_(i k)^(0) hat(phi)_(i k)
  $<eqn:exact-hat-pi>
The substantive piece of this expression is $hat(Phi)_i$. We derive it below:
  $
    hat(Phi)_i
    =
    (
      sum_(k in cal(L))
      text(
        fill: #red,
        phi_(i k)^0
      )
      hat(phi)_(i k)
    ) /
    (
      text(
        fill: #red,
        sum_(l in cal(L)) phi_(i l)^0
      )
    )
    = sum_(k in cal(L)) text(
      fill: #red,
      pi_(i k)^(0)
    )
    hat(phi)_(i k),
  $
where we have used @eqn:commute-probability to substitute in for $pi_(i k)^(0)$ (see the portions colored #text(red)[red]). We now combine @eqn:exact-hat-clearing and @eqn:exact-hat-pi to obtain
  $
    ((hat(A)_n) / hat(w)_n)^(1 / (1 - beta))
    &= [
      sum_(i in cal(L))
      (pi_(i n)^0 R_i^0 hat(R)_i (hat(w)_n slash hat(kappa)_(i n))^(theta)) /
      (sum_(k in cal(L)) pi_(i k)^(0) (hat(w)_k slash hat(kappa)_(i k))^(theta))
    ] 1 / L_n^0.
  $<eqn:exact-hat-combined>
What does this characterization of a counterfactual equilibria buy us? If we express a counterfactual as a set of proportional changes to the parameter values ${hat(bold(A)), hat(bold(kappa)), hat(bold(R))}$, then we only need data on initial conditional commuting probabilities $bold(pi)^0$, workplace population $bold(L)^0$, and residential population $bold(R)^0$ to solve for the proportional changes in wages $hat(bold(w))$ (using @eqn:exact-hat-combined) and conditional commuting probabilities $hat(bold(pi))$ (using @eqn:exact-hat-pi).

Inspired by this representation, we define
  $
    cal(Z)_(n)(tilde(bold(w)))
    eq.def
    ((hat(A)_n) / tilde(w)_n)^(1 / (1 - alpha))
    - [
      sum_(i in cal(L))
      (pi_(i n)^0 R_i^0 hat(R)_i (tilde(w)_n slash hat(kappa)_(i n))^(theta)) /
      (sum_(k in cal(L)) pi_(i k)^(0) (tilde(w)_k slash hat(kappa)_(i k))^(theta))
    ] 1 / L_n^0.
  $

We can use this vector-valued function $bold(cal(Z))(tilde(bold(w)))$ to compute the proportional changes in wages (and other equilibrium objects) in counterfactual equilibria. I provide pseudocode for this procedure below. I implement the algorithm in `analysis/model_A.ipynb`.

#stylebox[
  *Model A Algorithm:*
  + s = 0
  + $epsilon = "tolerance" + 1$
  + $tilde(bold(w))^0 = arrow(1)$
  + *while* $epsilon > "tolerance"$ *do*
  + #tab $tilde(bold(w))^(s + 1)$ = $tilde(bold(w))^s + kappa_w bold(cal(Z)) (tilde(bold(w))^s)$
  + #tab $epsilon = max {abs(bold(cal(Z)) (tilde(bold(w))^s))}$
  + #tab s = s + 1
  + *end while*
  + *return* $tilde(bold(w))^s$
]

// CM: add a discussion of zero flows

== A Richer Model (Model B)
We now consider a model with a housing market and residential choice. The mass of agents is denoted $overline(R)$. We no longer fix an agent's residential location.

=== Setup
Utility for an agent $omega$ residing in location $i$ and working in location $n$ is given by
  $
    U_(i n omega)
    = (c_(i n omega) / alpha)^alpha (h_(i n omega) / (1 - alpha))^(1 - alpha) b_(i n omega) / kappa_(i n)
  $<eqn:mB-utility>
where $c_(i n omega)$ is final good consumption, $h_(i n omega)$ is housing consumption, and $F_(i n)(b_(i n omega)) &= exp(-B_(i n) b_(i n omega)^(-theta))$. We've added a parameter $B_(i n)$ that governs average utility for agents that live in location $i$ and work in location $n$. The Cobb-Douglas form of @eqn:mB-utility implies that agents spend a constant fraction $alpha$ of their income on the final good and $(1 - alpha)$ on housing. The price of the final good is again $1$, and we denote the price of housing in location $i$ by $q_i$. Accordingly, indirect utility for an agent $omega$ residing in location $i$ and working in location $n$ with wage $w_n$ is given by
  $
    cal(U)_(i n omega)
    = ((alpha w_n) / alpha)^alpha ((alpha w_n) / (q_i (1 - alpha)))^(1 - alpha) b_(i n omega) / kappa_(i n)
    = ((w_(n) q_i^(alpha - 1)) / kappa_(i n)) b_(i n omega).
  $
A worker $omega$ now chooses both a residence and workplace:
  $
    {i, n}_(omega)^(*) eq.def arg max_(i,n in cal(L)) cal(U)_(i n omega).
  $
Similar to before, the Fréchet-distributed preference shock implies the following expression for the _unconditional_ residential and commuting probability
  $
    pi_(i n) & eq.def PP{{i, n}^(*) = {i, n}}
    = phi_(i n) Phi^(-1), \
    "where"quad
    phi_(i n) &eq.def B_(i n)((w_n q_i^(alpha - 1)) / kappa_(i n))^(theta) \
    "and"quad
    Phi &eq.def sum_(k in cal(L)) sum_(l in cal(L)) phi_(k l).
  $<eqn:mB-pi>
In what follows, it will be useful to define the mass of residents in each location $i$
  $
    R_i eq.def sum_(n in cal(L)) pi_(i n) overline(R),
  $
following the notation from Model A.

=== Housing Market
Each location $i$ has a fixed stock of land available for rent $H_i$. Landlords face no costs and spend all of their rental income on the final good to ensure goods market clearing. Let $overline(nu)_i$ denote the average income of residents in location $i$. We can than express _aggregate_ income for resident in location $i$
  $
    overline(nu)_i R_i &= sum_(n in cal(L)) pi_(i n) w_n overline(R).
  $
Land market clearing implies that housing expenditure (given by utility maximization) must equal landlord income in neighborhood $i$:
  $
    underbrace((1 - alpha) overline(nu)_i R_i, "Housing Expenditure")
    &= underbrace(H_i q_i, "Landlord Income")
  $

=== Firms
We maintain the same set of assumptions on the firm side as in Model A. This yields the wage equation and labor demand
  $
    w_n &= alpha A_n L_n^(alpha - 1) \
    arrow.r.double.long
    L_n &= ((alpha A_n) / w_n)^(1 / (1 - alpha)).
  $<eqn:mB-wages>

  


// First, the unconditional commuting probability is

// $
//   pi_(i n | i)
//   = pi_(i n) / pi_(i)^R
//   = Phi_(i n) / (sum_(k in cal(L)) Phi_(i k))
//   = [w_n / kappa_(i n)]^(theta) / (sum_(k in cal(L)) [w_k / kappa_(i k)]^(theta))
// $

=== Commuting Equilibrium
We now use the unconditional commuting probability in @eqn:mB-pi to define the commuting market clearing condition:
  $
    L_n = sum_(i in cal(L)) pi_(i n) overline(R).
  $

=== Counterfactual Equilibria
We proceed as in model A and derive the exact hat system.
  $
    hat(phi)_(i n)
    &= hat(B)_(i n) ((hat(w)_n hat(q)_i^(alpha - 1)) / hat(kappa)_(i n))^theta \
    hat(pi)_(i n)
    // = (Phi_(i n)^0 hat(Phi)_(i n))
    // / (sum_(k in cal(L)) sum_(l in cal(L)) Phi_(k l)^0 hat(Phi)_(k l))
    &= (hat(phi)_(i n))
    / (sum_(k in cal(L)) sum_(l in cal(L)) pi_(k l)^0 hat(phi)_(k l)) \
    hat(R)_i
    &= (overline(R)^0 hat(overline(R))) / R_i^0 sum_(n in cal(L)) pi_(i n)^0 hat(pi)_(i n) \
    ((hat(A)_n) / hat(w)_n)^(1 / (1 - beta))
    &= ((overline(R)^0 hat(overline(R))) / L_n^0) sum_(i in cal(L)) pi_(i n)^0 hat(pi)_(i n) \
    hat(overline(nu))_i hat(R)_i
    &= hat(overline(R)) ((sum_(n in cal(L)) pi_(i n)^0 w_n^0 hat(pi)_(i n) hat(w)_n) / (sum_(k in cal(L)) pi_(i k)^0 w_k^0)) \
    hat(q)_i
    &= (hat(overline(nu))_i hat(R_i)) / hat(H)_i
  $<eqn:mB-hat-system>
We combine the expressions from above and define
  $
    cal(Z)_(n)(tilde(bold(w)), tilde(bold(q)))
    &eq.def
    ((hat(A)_n) / hat(w)_n)^(1 / (1 - beta))
    - ((overline(R)^0 hat(overline(R))) / L_n^0) sum_(i in cal(L)) (pi_(i n)^0 hat(B)_(i n) (hat(w)_n hat(q)_i^(alpha - 1) slash hat(kappa)_(i n))^theta)
    / (sum_(k in cal(L)) sum_(l in cal(L)) pi_(k l)^0 hat(B)_(k l) (hat(w)_l hat(q)_k^(alpha - 1) slash hat(kappa)_(k l))^theta) \
    cal(Q)_(i)(tilde(bold(w)), tilde(bold(q)))
    &eq.def
    (hat(overline(R)) / hat(H)_i) ((sum_(n in cal(L)) pi_(i n)^0 w_n^0 hat(pi)_(i n) hat(w)_n) / (sum_(k in cal(L)) pi_(i k)^0 w_k^0)).
  $

  // CM: substitute in expression for hat(pi)_(i n)
  
#stylebox[
  *Model B Algorithm:*
  + s = 0
  + $epsilon = "tolerance" + 1$
  + $tilde(bold(w))^0 = tilde(bold(q))^0 = arrow(1)$
  + *while* $epsilon > "tolerance"$ *do*
  + #tab $tilde(bold(q))^(s + 1) = (1 - kappa_q) tilde(bold(q))^(s) + kappa_q bold(cal(Q))(tilde(bold(w))^(s), tilde(bold(q))^(s))$
  + #tab $tilde(bold(w))^(s + 1)$ = $tilde(bold(w))^s + kappa_w bold(cal(Z)) (tilde(bold(w))^s, tilde(bold(q))^s)$
  + #tab $epsilon = max {abs(bold(cal(Z)) (tilde(bold(w))^s, tilde(bold(q))^s))}$
  + #tab s = s + 1
  + *end while*
  + *return* $tilde(bold(w))^s, tilde(bold(q))^s$
]

= Data and Calibration
```
In progress.
```

= Counterfactual Exercises
```
In progress.
```

== Local Productivity Shock
#figure(caption: [Local Productivity Shock, Simple QSM, $hat(bold(A))$])[
  #image("out/productivity_shock_A_hat.png", width: 50%)
]

#figure(caption: [Local Productivity Shock, Simple QSM, $hat(bold(w))$])[
  #stack(
    dir: ltr,
    image("out/productivity_shock_w_hat.png", width: 50%),
    image("out/productivity_shock_w_hat_censor.png", width: 50%)
  )
]

#figure(caption: [Local Productivity Shock, Simple QSM, $hat(bold(w))$])[
  #image("out/productivity_shock_w_hat_focus.png", width: 50%)
]