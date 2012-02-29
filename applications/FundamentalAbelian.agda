{-# OPTIONS --type-in-type --without-K #-}

open import lib.Prelude
open Paths

module applications.FundamentalAbelian (A : Set) (base : A) where

    π1El : Set
    π1El = base ≃ base
    π2El : Set
    π2El = _≃_{π1El} Refl Refl 

    _⊙_ : π2El → π2El → π2El 
    a ⊙ b =  resp∘ a b

    ⊙-unit-l : (p : π2El) → (Refl ⊙ p) ≃ p
    ⊙-unit-l p = ∘-unit-l p ∘ resp∘-unit-l p -- because we know the base is Refl, the adjustment cancels

    ⊙-unit-r : (a : π2El) → (a ⊙ Refl) ≃ a
    ⊙-unit-r a = resp∘-unit-r a 

    interchange : (a b c d : _) → ((a ∘ b) ⊙ (c ∘ d)) ≃ ((a ⊙ c)  ∘ (b ⊙ d))
    interchange a b c d = trans-resp∘-ichange _ _ d _ c _ _ b _ a

    same : (a b : π2El) → (a ∘ b) ≃ (a ⊙ b)
    same a b = (( a         ∘ b)          ≃〈 resp (λ x → x ∘ b) (sym (⊙-unit-r a)) 〉 
                ((a ⊙ Refl) ∘ b)          ≃〈 resp (λ x → (a ⊙ Refl) ∘ x) (sym (⊙-unit-l b)) 〉 
                ((a ⊙ Refl) ∘ (Refl ⊙ b)) ≃〈 sym (interchange a Refl Refl b) 〉 
                ((a ∘ Refl) ⊙ (Refl ∘ b))  ≃〈 resp (λ x → x ⊙ (Refl ∘ b)) (trans-unit-l a) 〉 
                (a ⊙ (Refl ∘ b))           ≃〈 resp (λ x → a ⊙ x) (∘-unit-l b) 〉 
                (a ⊙ b) 
                ∎)

    abelian : (a b : π2El) → (a ∘ b) ≃ (b ∘ a)
    abelian a b = (a ∘ b) ≃〈 resp (λ x → x ∘ b) (sym (⊙-unit-l a)) 〉 
                     ((Refl ⊙ a) ∘ b)          ≃〈 resp (λ x → (Refl ⊙ a) ∘ x) (sym (⊙-unit-r b)) 〉 
                     ((Refl ⊙ a) ∘ (b ⊙ Refl)) ≃〈 ! (interchange Refl b a Refl) 〉 
                     ((Refl ∘ b) ⊙ (a ∘ Refl)) ≃〈 resp (λ x → x ⊙ (a ∘ Refl)) (∘-unit-l b) 〉 
                     (b         ⊙ (a ∘ Refl)) ≃〈 resp (λ x → b ⊙ x) (∘-unit-r a) 〉 
                     (b ⊙ a)                   ≃〈 sym (same b a) 〉 
                     (b ∘ a) 
                     ∎

{-
    -- for reference, this is the minimal generalization of the IH that goes through
    -- for proving the interchange law
    ichange : (p q : π1El) 
             → (a : Id p q) (r : π1El) (b : Id q r) (p' q' : π1El) 
               (c : Id p' q') (r' : π1El) (d : Id q' r') 
             → Id (resptrans (trans a b) (trans c d)) (trans (resptrans a c) (resptrans b d))
    ichange p q a = jay
                      (λ p' q' a' →
                         (r : π1El) (b : Id q' r) (p0 q0 : π1El) (c : Id p0 q0) (r' : π1El)
                         (d : Id q0 r') →
                         Id (resptrans (trans a' b) (trans c d))
                         (trans (resptrans a' c) (resptrans b d)))
                      a
                      (λ pq r b →
                         jay
                         (λ pq' r' b' →
                            (p' q' : π1El) (c : Id p' q') (r0 : π1El) (d : Id q' r0) →
                            Id (resptrans (trans Refl b') (trans c d))
                            (trans (resptrans Refl c) (resptrans b' d)))
                         b
                         (λ pqr p' q' c →
                            jay
                            (λ p0 q0 c' →
                               (r' : π1El) (d : Id q0 r') →
                               Id (resptrans Refl (trans c' d))
                               (trans (resptrans Refl c') (resptrans Refl d)))
                            c
                            (λ p'q' r' d →
                               jay
                               (λ p'q0 r0 d' →
                                  Id (resptrans Refl (trans Refl d'))
                                  (trans Refl (resptrans Refl d')))
                               d (λ _ → Refl))))
-}
    
    -- ENH: can you relax the restriction that the base point is identity?
    -- abelian' : {loop : Id base base} {a b : Id loop loop} → Id (trans a b) (trans b a)