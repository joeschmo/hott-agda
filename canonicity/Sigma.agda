open import lib.Prelude 
open Paths
open import canonicity.Reducibility
-- both Σ itself is lazy,
-- and values of Σ type are lazy
module canonicity.Sigma where
    -- WARNING: never use subst/resp on these
    data ΣValue {Γ : Set} (vΓ : ValuableTy Γ) {A : Γ -> Set} (sA : Ty vΓ A) : (Σ A) -> Set where
      cpair : {M : _} 
              -> (vM : Valuable vΓ M) -> {N : _} -> Valuable (tred' sA vM) N 
              -> ΣValue vΓ sA (M , N)
  
    data ΣValue≃ {Γ : Set} (vΓ : ValuableTy Γ) {A : Γ -> Set} (sA : Ty vΓ A) 
                 : {M N : (Σ A)} (vM : ΣValue vΓ sA M) (vN : ΣValue vΓ sA N) (α : M ≃ N) -> Set where
      cpair≃ : ∀ {M1 M2 α} {vM1 : Valuable vΓ M1} {vM2 : Valuable vΓ M2} 
              -> (vα : Valuable≃ vΓ vM1 vM2 α)
              -> ∀ {N1 N2 β} {vN1 : Valuable (tred' sA vM1) N1} {vN2 : Valuable (tred' sA vM2) N2 }
              -> Valuable≃ (tred' sA vM2) (mred' (ssubst' sA vα) vN1)
                                          vN2
                                          β
              -> ΣValue≃ vΓ sA (cpair vM1 vN1) (cpair vM2 vN2) (pair≃ α β) 
  
    Σval : {Γ : Set} (vΓ : ValuableTy Γ) {A : Γ -> Set} (sA : Ty vΓ A) -> ValueTy (Σ A)
    Σval vΓ sA = record { Value = ΣValue vΓ sA; 
                          Value≃ = ΣValue≃ vΓ sA; 
                          vRefl = {!!}; v! = {!!}; v∘ = {!!} }
    
    Σc : {Γ : Set} (vΓ : ValuableTy Γ) {A : Γ -> Set} (sA : Ty vΓ A) -> ValuableTy (Σ A)
    Σc {Γ} vΓ {A} sA = valuablety (Σ (\ (x : Γ) -> A x))
                                  (Σval vΓ sA) Refl FIXMEEval


    mfst :  {Γ : Set} (sΓ : ValuableTy Γ) {A : Γ -> Set} (sA : Ty sΓ A) 
         -> Map (Σc sΓ sA) sΓ fst
    mfst sΓ sA = smap (λ {(cpair vM vN) → vM})
                      (λ { {._} (cpair≃{_}{_}{α} vα{_}{_}{β} vβ) → head-expand≃ vα (Σ≃β1 α β) FIXMEEval}) -- head-expand
                    

    svar : {Γ : Set} (sΓ : ValuableTy Γ) {A : Γ -> Set} (sA : Ty sΓ A) 
        -> Tm (Σc sΓ sA) (mto sA (mfst sΓ sA)) snd
    svar sΓ sA = tm (λ {(cpair vM vN) → vN})
                    (λ { {._} (cpair≃ vα vβ) → valuable≃ _ (val≃ vβ) (ev≃ vβ ∘ {!!}) FIXMEEval})