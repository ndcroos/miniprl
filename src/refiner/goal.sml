(* See goal.sig for docs *)
structure Goal :> GOAL =
struct
  datatype visible = HIDDEN | VISIBLE
  type context = (visible * Term.t) list
  datatype t = >> of context * Term.t

  fun nth irr i (cxt : context) =
    (case (irr, List.nth (cxt, i)) of
         (false, (HIDDEN, _)) => NONE (* The only case returning NONE *)
       | (_, (_, t)) => SOME (Term.lift 0 (i + 1) t))
    handle Subscript => NONE
end

(* This is the particular implementation of tactics
 * we're going to use throughout the refiner. It uses
 * the goals we've just defined as tactic goals and
 * derivations in the type theory as the sort of derivation
 * that tactics produce.
 *)
structure PrlTactic :> TACTIC
  where type goal = Goal.t
    and type derivation = Derivation.t =
struct
  type derivation = Derivation.t
  type goal = Goal.t
  type result = { evidence : derivation list -> derivation
                , goals : goal list
                }

  type 'a choice = (result, 'a) TacticMonad.t
  type t = goal -> result choice
end
