theory Hygge_Theory
imports
  "Hygge"
  "Denotational"

begin
(** TODO list of desired properties
  - Soundness
  - Completeness
  - Termination
  - Composition
  - Decidability
*)

fun HeronConf_interpretation :: "(system \<times> instant_index \<times> TESL_formula \<times> TESL_formula) \<Rightarrow> run set" ("\<lbrakk> _ \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n") where
  "\<lbrakk> \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi> \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n = \<lbrakk>\<lbrakk> \<Gamma> \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi> \<nabla> n \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi> \<nabla> Suc n \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"

(**) section \<open>Soundness\<close> (**)

theorem reduction_refinement:
  assumes "\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1  \<hookrightarrow>  \<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2"
  shows "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L  \<supseteq>  \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
  proof (insert assms, erule operational_semantics_step.cases)
  show "\<And>\<Gamma> n \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> [] \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (\<Gamma>, Suc n \<turnstile> \<Phi> \<triangleright> []) \<Longrightarrow>
       consistent_run \<Gamma> \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    by auto
  show "\<And>\<Gamma> n K \<tau> \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K sporadic \<tau>) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (\<Gamma>, n \<turnstile> \<Psi> \<triangleright> (K sporadic \<tau>) # \<Phi>) \<Longrightarrow>
       consistent_run \<Gamma> \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_sporadic_cases
    by (smt Int_subset_iff Pair_inject TESL_interpretation_at_index_cons_morph inf.cobounded1 inf.cobounded2 subset_trans sup.cobounded2)
  show "\<And>K n \<tau> \<Gamma> \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K sporadic \<tau>) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K \<Up> n # K \<Down> n @ \<lfloor> \<tau> \<rfloor> # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       consistent_run (K \<Up> n # K \<Down> n @ \<lfloor> \<tau> \<rfloor> # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_sporadic_cases
  proof -
    fix K :: clock and n :: nat and \<tau> :: tag_const and \<Gamma> :: "constr list" and \<Psi> :: "TESL_atomic list" and \<Phi> :: "TESL_atomic list"
    assume a1: "(\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K \<Up> n # K \<Down> n @ \<lfloor> \<tau> \<rfloor> # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>)"
    assume a2: "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K sporadic \<tau>) # \<Psi> \<triangleright> \<Phi>)"
    have f3: "\<lbrakk> K \<Up> n \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk> K \<Down> n @ \<lfloor> \<tau> \<rfloor> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Gamma> \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n) = \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n"
      using a1 by force
    have "(\<lbrakk> K \<Up> n \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk> K \<Down> n @ \<lfloor> \<tau> \<rfloor> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<union> \<lbrakk> K sporadic \<tau> \<nabla> Suc n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L) \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using a2 a1 by (metis (no_types) Pair_inject TESL_interp_at_index_sporadic_cases TESL_interpretation_at_index_cons_morph)
    then show "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using f3 a2 a1 by blast
  qed
  show "\<And>\<Gamma> n K\<^sub>1 \<tau> K\<^sub>2 \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (\<Gamma>, n \<turnstile> \<Psi> \<triangleright> (K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Phi>) \<Longrightarrow>
       consistent_run \<Gamma> \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_sporadicon_cases
    proof -
    fix \<Gamma> :: "constr list" and n :: nat and K\<^sub>1 :: clock and \<tau> :: tag_expr and K\<^sub>2 :: clock and \<Psi> :: "TESL_atomic list" and \<Phi> :: "TESL_atomic list"
    assume a1: "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi> \<triangleright> \<Phi>)"
    assume a2: "(\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (\<Gamma>, n \<turnstile> \<Psi> \<triangleright> (K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Phi>)"
    have "n\<^sub>1 = n \<and> (\<Psi>\<^sub>1, \<Phi>\<^sub>1) = ((K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi>, \<Phi>)"
      using a1 by fastforce
    then have f3: "\<lbrakk> K\<^sub>1 sporadic \<tau> on K\<^sub>2 \<nabla> Suc n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk> K\<^sub>1 sporadic \<tau> on K\<^sub>2 \<nabla> n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using TESL_interp_at_index_sporadicon_cases by blast
    have f4: "\<lbrakk> K\<^sub>1 sporadic \<tau> on K\<^sub>2 \<nabla> Suc n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using a2 a1 by force
    have "\<lbrakk> K\<^sub>1 sporadic \<tau> on K\<^sub>2 \<nabla> n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using a2 a1 by force
    then show "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using f4 f3 a2 a1 by blast
  qed
  show "\<And>K\<^sub>1 n K\<^sub>2 \<tau> \<Gamma> \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<Up> n # K\<^sub>2 \<Down> n @ \<tau> # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       consistent_run (K\<^sub>1 \<Up> n # K\<^sub>2 \<Down> n @ \<tau> # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_sporadicon_cases
    proof -
    fix K\<^sub>1 :: clock and n :: nat and K\<^sub>2 :: clock and \<tau> :: tag_expr and \<Gamma> :: "constr list" and \<Psi> :: "TESL_atomic list" and \<Phi> :: "TESL_atomic list"
    assume a1: "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 sporadic \<tau> on K\<^sub>2) # \<Psi> \<triangleright> \<Phi>)"
    assume a2: "(\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<Up> n # K\<^sub>2 \<Down> n @ \<tau> # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> \<Phi>)"
    then have f3: "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L)) \<subseteq> (\<Inter>t\<in>set \<Psi>\<^sub>2. \<lbrakk> t \<nabla> n\<^sub>2 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L) \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<Inter>t\<in>set \<Phi>\<^sub>1. \<lbrakk> t \<nabla> Suc n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L))"
    using a1 TESL_interpretation_at_index_fixpoint by force
    have f4: "\<lbrakk> K\<^sub>1 \<Up> n \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk> K\<^sub>2 \<Down> n @ \<tau> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk> K\<^sub>2 \<Down> n @ \<tau> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n) \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L))) = \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L)"
      using a2 a1 by force
    have "\<lbrakk> K\<^sub>1 sporadic \<tau> on K\<^sub>2 \<nabla> n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> (\<Inter>t\<in>set \<Psi>\<^sub>2. \<lbrakk> t \<nabla> n\<^sub>2 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L) \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<Inter>t\<in>set \<Phi>\<^sub>1. \<lbrakk> t \<nabla> Suc n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L)) = (\<Inter>t\<in>set \<Psi>\<^sub>1. \<lbrakk> t \<nabla> n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L) \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<Inter>t\<in>set \<Phi>\<^sub>1. \<lbrakk> t \<nabla> Suc n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L)))"
      using a2 a1 by simp
    then have "(\<lbrakk> K\<^sub>1 \<Up> n \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk> K\<^sub>2 \<Down> n @ \<tau> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<union> \<lbrakk> K\<^sub>1 sporadic \<tau> on K\<^sub>2 \<nabla> Suc n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L) \<inter> ((\<Inter>t\<in>set \<Psi>\<^sub>2. \<lbrakk> t \<nabla> n\<^sub>2 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L) \<inter> (\<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<Inter>t\<in>set \<Phi>\<^sub>1. \<lbrakk> t \<nabla> Suc n\<^sub>1 \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L))) = \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> (\<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L)"
      by (metis Int_absorb TESL_interp_at_index_sporadicon_cases TESL_interpretation_at_index_fixpoint inf_aci(2) inf_left_commute)
    then show "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using f4 f3 by blast
  qed
  show "\<And>K\<^sub>1 n \<alpha> K\<^sub>2 \<beta> \<Gamma> \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (\<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>1, n) \<doteq> \<alpha> * \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) + \<beta> # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> (tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Phi>) \<Longrightarrow>
       consistent_run (\<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>1, n) \<doteq> \<alpha> * \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) + \<beta> # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_tagrel_cases
    proof -
      fix K\<^sub>1 :: clock and n :: nat and \<alpha> :: tag_const and K\<^sub>2 :: clock and \<beta> :: tag_const and \<Gamma> :: "constr list" and \<Psi> :: "TESL_atomic list" and \<Phi> :: "TESL_atomic list"
    assume a1: "(\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (\<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>1, n) \<doteq> \<alpha> * \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) + \<beta> # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> (tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Phi>)"
    assume a2: "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Psi> \<triangleright> \<Phi>)"
    have f3: "\<forall>ts tsa tsb tsc. (ts::TESL_atomic list, tsa::TESL_atomic list) \<noteq> (tsb, tsc) \<or> ts = tsb \<and> tsa = tsc"
      by fastforce
    have f4: "n\<^sub>2 = n \<and> (\<Psi>\<^sub>2, \<Phi>\<^sub>2) = (\<Psi>, (tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Phi>)"
      using a1 by fastforce
    have f5: "\<lbrakk>\<lbrakk> (tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Phi> \<nabla> Suc n \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using a1 by force
    have f6: "n\<^sub>1 = n \<and> (\<Psi>\<^sub>1, \<Phi>\<^sub>1) = ((tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta>) # \<Psi>, \<Phi>)"
      using a2 by fastforce
    have f7: "\<lbrakk>\<lbrakk> \<Phi> \<nabla> Suc n \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using a2 by force
    have f8: "\<lbrakk>\<lbrakk> \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>1, n) \<doteq> \<alpha> * \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) + \<beta> # \<Gamma> \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n = \<lbrakk> \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>1, n) \<doteq> \<alpha> * \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) + \<beta> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n"
      using a2 by force
    have f9: "\<lbrakk> tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta> \<nabla> Suc n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> (\<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk> \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>1, n) \<doteq> \<alpha> * \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) + \<beta> \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n) = \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using f6 f4 f3 by (metis Int_commute TESL_interp_at_index_tagrel_cases TESL_interpretation_at_index_cons_morph inf_sup_aci(3))
    have "\<lbrakk> tag-relation K\<^sub>1 = \<alpha> * K\<^sub>2 + \<beta> \<nabla> Suc n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using f7 f5 by simp
    then show "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using f9 f8 a1 by blast
  qed
  show "\<And>K\<^sub>1 n \<Gamma> K\<^sub>2 \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 implies K\<^sub>2) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<not>\<Up> n # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> (K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<Longrightarrow>
       consistent_run (K\<^sub>1 \<not>\<Up> n # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_implies_cases
    using [[smt_solver = cvc4]]
    by (smt Int_subset_iff Pair_inject TESL_interpretation_at_index.elims inf.cobounded2 inf.mono inf_sup_aci(2) list.simps(1) list.simps(3) sup.cobounded1 symbolic_run_interpretation.simps(2))
  show "\<And>K\<^sub>1 n K\<^sub>2 \<Gamma> \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 implies K\<^sub>2) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<Up> n # K\<^sub>2 \<Up> n # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> (K\<^sub>1 implies K\<^sub>2) # \<Phi>) \<Longrightarrow>
       consistent_run (K\<^sub>1 \<Up> n # K\<^sub>2 \<Up> n # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_implies_cases
    using [[smt_solver = cvc4]]
    by (smt Int_subset_iff Pair_inject TESL_interpretation_at_index_cons_morph inf_le1 inf_sup_aci(2) le_iff_inf sup.cobounded2 symbolic_run_interpretation.simps(2))
  show "\<And>K\<^sub>1 n \<Gamma> \<delta>\<tau> K\<^sub>2 K\<^sub>3 \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<not>\<Up> n # \<Gamma>, n \<turnstile> \<Psi> \<triangleright> (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<Longrightarrow>
       consistent_run (K\<^sub>1 \<not>\<Up> n # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    using TESL_interp_at_index_timedelayed_cases
    using [[smt_solver = cvc4]]
    by (smt Int_subset_iff Pair_inject TESL_interpretation_at_index_cons_morph inf.cobounded2 inf_le1 subset_trans sup.cobounded1 symbolic_run_interpretation.simps(2))
  show "\<And>K\<^sub>1 n \<Gamma> \<delta>\<tau> K\<^sub>2 K\<^sub>3 \<Psi> \<Phi>.
       (\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi> \<triangleright> \<Phi>) \<Longrightarrow>
       (\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<Up> n # \<Gamma>, n \<turnstile> (K\<^sub>3 sporadic \<lfloor> \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) \<oplus> \<delta>\<tau> \<rfloor> on K\<^sub>2) # \<Psi> \<triangleright> (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>) \<Longrightarrow>
       consistent_run (K\<^sub>1 \<Up> n # \<Gamma>) \<Longrightarrow>
       \<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    proof -
    fix K\<^sub>1 :: clock and n :: nat and \<Gamma> :: "constr list" and \<delta>\<tau> :: tag_const and K\<^sub>2 :: clock and K\<^sub>3 :: clock and \<Psi> :: TESL_formula and \<Phi> :: TESL_formula
    assume a1: "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1) = (\<Gamma>, n \<turnstile> (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Psi> \<triangleright> \<Phi>)"
    assume a2: "(\<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) = (K\<^sub>1 \<Up> n # \<Gamma>, n \<turnstile> (K\<^sub>3 sporadic \<lfloor> \<tau>\<^sub>v\<^sub>a\<^sub>r (K\<^sub>2, n) \<oplus> \<delta>\<tau> \<rfloor> on K\<^sub>2) # \<Psi> \<triangleright> (K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3) # \<Phi>)"
    have tdby_cases_corrollary: "\<lbrakk> K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3 \<nabla> n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<supseteq>
        \<lbrakk> K\<^sub>1 \<Up> n \<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk> K\<^sub>3 sporadic \<lfloor>\<tau>\<^sub>v\<^sub>a\<^sub>r(K\<^sub>2, n) \<oplus> \<delta>\<tau>\<rfloor> on K\<^sub>2 \<nabla> n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk> K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3 \<nabla> Suc n \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using TESL_interp_at_index_timedelayed_cases by blast
    then show "\<lbrakk>\<lbrakk> \<Gamma>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<nabla> n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>2 \<nabla> Suc n\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<subseteq> \<lbrakk>\<lbrakk> \<Gamma>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<nabla> n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> \<Phi>\<^sub>1 \<nabla> Suc n\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
      using a1 a2 by auto
    qed
  qed

theorem reduction_refinement':
  assumes "\<S>\<^sub>1 \<hookrightarrow> \<S>\<^sub>2"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
  by (metis reduction_refinement HeronConf_interpretation.elims assms)

(* TODO: Need to show the same property for an arbitrary number of reduction steps*)
(* Playing with [rel] type *)
theorem reduction_refinement'':
  assumes "(\<S>\<^sub>1, \<S>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<up>"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
  proof -
    have "\<S>\<^sub>1 \<hookrightarrow> \<S>\<^sub>2" using assms by auto
    then show ?thesis using reduction_refinement' by auto
  qed

theorem reduction_refinement_2:
  assumes "(\<S>\<^sub>1, \<S>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<up> ^^ 2"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
  proof -
    obtain \<S>' where "(\<S>\<^sub>1, \<S>') \<in> \<hookrightarrow>\<^sup>\<up> \<and> (\<S>', \<S>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<up>" sorry
    have "\<S>\<^sub>1 \<hookrightarrow> \<S>\<^sub>2" using assms sorry
    then show ?thesis using reduction_refinement' sorry
  qed

theorem reduction_refinement_general:
  assumes "(\<S>\<^sub>1, \<S>\<^sub>2) \<in> (\<hookrightarrow>\<^sup>\<up> ^^ n)"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
  proof (induct n)
    case 0
    then have *: "(\<S>\<^sub>1, \<S>\<^sub>2) \<in> (\<hookrightarrow>\<^sup>\<up> ^^ 0) \<Longrightarrow> \<S>\<^sub>1 = \<S>\<^sub>2"
      by auto
    moreover have "\<S>\<^sub>1 = \<S>\<^sub>2" using *
      sorry
    ultimately show ?case by auto
  next
    case (Suc n)
    then show ?case sorry
  qed

theorem
  assumes "(\<S>\<^sub>1, \<S>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<up>\<^sup>*"
  shows "\<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<supseteq> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
  apply (insert assms)
  proof -
    have "\<S>\<^sub>1 = \<S>\<^sub>2 \<Longrightarrow> (\<S>\<^sub>1, \<S>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<up>\<^sup>* \<Longrightarrow> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<subseteq> \<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n "
      by auto
    moreover have "\<S>\<^sub>1 \<noteq> \<S>\<^sub>2 \<Longrightarrow> (\<S>\<^sub>1, \<S>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<up>\<^sup>* \<Longrightarrow> \<lbrakk> \<S>\<^sub>2 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n \<subseteq> \<lbrakk> \<S>\<^sub>1 \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
      (* apply (frule rtrancl_into_rtrancl) *)
      proof -
        have "undefined" sorry
        show ?thesis sorry
      qed
    ultimately show ?thesis using assms by blast
  qed

(* To start solving specification [\<Psi>], we start at configuration [], 0 \<turnstile> \<Psi> \<triangleright> [] *)
lemma solve_start:
  shows "\<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk> [], 0 \<turnstile> \<Psi> \<triangleright> [] \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n"
  proof -
    have "\<lbrakk>\<lbrakk> \<Psi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Psi> \<nabla> 0 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    by (simp add: TESL_interpretation_at_index_zero')
    moreover have "\<lbrakk> [], 0 \<turnstile> \<Psi> \<triangleright> [] \<rbrakk>\<^sub>H\<^sub>e\<^sub>r\<^sub>o\<^sub>n = \<lbrakk>\<lbrakk> [] \<rbrakk>\<rbrakk>\<^sub>s\<^sub>y\<^sub>m\<^sub>r\<^sub>u\<^sub>n \<inter> \<lbrakk>\<lbrakk> \<Psi> \<nabla> 0 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L \<inter> \<lbrakk>\<lbrakk> [] \<nabla> Suc 0 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    by simp
    ultimately show ?thesis by auto
  qed

(**) section \<open>Termination of instantataneous formulae elimination\<close> (**)
(* Idea: A bounded monotonic sequence is convergent *)
fun count_interpretation :: "TESL_formula \<Rightarrow> nat" ("\<lbrakk>\<lbrakk> _ \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t") where
    "\<lbrakk>\<lbrakk> [] \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t = (0::nat)"
  | "\<lbrakk>\<lbrakk> \<phi> # \<Phi> \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t = (case \<phi> of
                        _ sporadic _ on _ \<Rightarrow> 1 + \<lbrakk>\<lbrakk> \<Phi> \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t
                      | _                 \<Rightarrow> 2 + \<lbrakk>\<lbrakk> \<Phi> \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t)"
lemma present_strictly_decreasing:
  assumes "\<Gamma>\<^sub>1, n \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1  \<hookrightarrow>  \<Gamma>\<^sub>2, n \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2"
  shows "\<lbrakk>\<lbrakk> \<Psi>\<^sub>1 \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t > \<lbrakk>\<lbrakk> \<Psi>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>c\<^sub>n\<^sub>t"
  by (insert assms, erule operational_semantics_step.cases, auto)

lemma run_index_progress:
  assumes "\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1  \<hookrightarrow>  \<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2"
  shows "n\<^sub>2 = Suc n\<^sub>1 \<or> n\<^sub>2 = n\<^sub>1"
  by (insert assms, erule operational_semantics_step.cases, auto)

lemma run_index_progress_simlstep:
  assumes "(\<Gamma>\<^sub>1, n\<^sub>1 \<turnstile> \<Psi>\<^sub>1 \<triangleright> \<Phi>\<^sub>1, \<Gamma>\<^sub>2, n\<^sub>2 \<turnstile> \<Psi>\<^sub>2 \<triangleright> \<Phi>\<^sub>2) \<in> \<hookrightarrow>\<^sup>\<nabla>"
  shows "n\<^sub>2 = Suc n\<^sub>1"
  apply (insert assms)
  apply auto
  sorry

(**) section \<open>Composition\<close> (**)

lemma run_composition:
  assumes "\<Gamma>, n \<turnstile> \<Psi>\<^sub>1 \<triangleright> (\<Phi>\<^sub>1 @ \<Phi>\<^sub>2)  \<hookrightarrow>  \<Gamma>', n' \<turnstile> \<Psi>\<^sub>2 \<triangleright> (\<Phi>\<^sub>1' @ \<Phi>\<^sub>2')"
  shows "\<lbrakk>\<lbrakk> \<Phi>\<^sub>1 @ \<Phi>\<^sub>2 \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L = \<lbrakk>\<lbrakk> \<Phi>\<^sub>1' @ \<Phi>\<^sub>2' \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
  apply (insert assms, erule operational_semantics_step.cases, auto)
  (* nitpick *)
  sorry

lemma composition:
  assumes "K\<^sub>1 time-delayed by \<delta>\<tau> on K\<^sub>2 implies K\<^sub>3 \<notin> set \<Phi> \<union> set \<Phi>'"
  assumes "\<TTurnstile> \<Gamma>\<^sub>1, n \<turnstile> [] \<triangleright> \<Phi>\<^sub>1"
  assumes "\<TTurnstile> \<Gamma>\<^sub>2, n \<turnstile> [] \<triangleright> \<Phi>\<^sub>2"
  assumes "consistency_run (\<Gamma>\<^sub>1 @ \<Gamma>\<^sub>2)"
  shows   "\<TTurnstile> \<Gamma>\<^sub>1 @ \<Gamma>\<^sub>2, n \<turnstile> [] \<triangleright> \<Phi>\<^sub>1 @ \<Phi>\<^sub>2"
  oops

(**) section \<open>Decidability\<close> (**)
fun tagrel_consistent :: "TESL_formula \<Rightarrow> bool" where
  "tagrel_consistent \<Phi> = undefined"

lemma existence:
  (* Assumption that the linear system made of tag relations is consistent *)
  assumes "tagrel_consistent \<Phi>"
  shows "\<exists>\<rho>. \<rho> \<in> \<lbrakk>\<lbrakk> \<Phi> \<rbrakk>\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
oops
(* proof (induction \<Phi>) *)

end