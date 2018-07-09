theory TESLStuttering
imports TESLStutteringLemmas

begin

text {*
  Sporadic specifications are preserved in a dilated run.
*}
lemma sporadic_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c sporadic \<lparr>\<tau>\<rparr> on c'\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c sporadic \<lparr>\<tau>\<rparr> on c'\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f
    where "dilating f sub r" by blast
  hence "\<forall>n c. time ((Rep_run sub) n c) = time ((Rep_run r) (f n) c)
           \<and> hamlet ((Rep_run sub) n c) = hamlet ((Rep_run r) (f n) c)" by (simp add: dilating_def)
  moreover from assms(2) have
    "sub \<in> {r. \<exists> n. hamlet ((Rep_run r) n c) \<and> time ((Rep_run r) n c') = \<tau>}" by simp
  from this obtain k where "time ((Rep_run sub) k c') = \<tau> \<and> hamlet ((Rep_run sub) k c)" by auto
  ultimately have "time ((Rep_run r) (f k) c') = \<tau> \<and> hamlet ((Rep_run r) (f k) c)" by simp
  thus ?thesis by auto
qed

text {*
  Implications are preserved in a dilated run.
*}
theorem implies_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 implies c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 implies c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where "dilating f sub r" by blast
  moreover from assms(2) have
    "sub \<in> {r. \<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> hamlet ((Rep_run r) n c\<^sub>2)}" by simp
  hence "\<forall>n. hamlet ((Rep_run sub) n c\<^sub>1) \<longrightarrow> hamlet ((Rep_run sub) n c\<^sub>2)" by simp
  ultimately have "\<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> hamlet ((Rep_run r) n c\<^sub>2)"
    using ticks_imp_ticks_subk ticks_sub by blast
  thus ?thesis by simp
qed

theorem implies_not_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 implies not c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 implies not c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where "dilating f sub r" by blast
  moreover from assms(2) have
    "sub \<in> {r. \<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> \<not> hamlet ((Rep_run r) n c\<^sub>2)}" by simp
  hence "\<forall>n. hamlet ((Rep_run sub) n c\<^sub>1) \<longrightarrow> \<not> hamlet ((Rep_run sub) n c\<^sub>2)" by simp
  ultimately have "\<forall>n. hamlet ((Rep_run r) n c\<^sub>1) \<longrightarrow> \<not> hamlet ((Rep_run r) n c\<^sub>2)"
    using ticks_imp_ticks_subk ticks_sub by blast
  thus ?thesis by simp
qed

text {*
  Precedence relations are preserved in a dilated run.
*}
theorem weakly_precedes_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 weakly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 weakly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  from assms(2) have
    "sub \<in> {r. \<forall>n. (run_tick_count r c\<^sub>2 n) \<le> (run_tick_count r c\<^sub>1 n)}" by simp
  hence "\<forall>n. (run_tick_count sub c\<^sub>2 n) \<le> (run_tick_count sub c\<^sub>1 n)" by simp
  from dil_tick_count[OF assms(1) this] have "\<forall>n. (run_tick_count r c\<^sub>2 n) \<le> (run_tick_count r c\<^sub>1 n)" by simp
  thus ?thesis 
    using TESL_interpretation_atomic.simps(8)[of "c\<^sub>1" "c\<^sub>2"] by simp
qed


text {*
  Time delayed relations are preserved in a dilated run.
*}
theorem time_delayed_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk> a time-delayed by \<delta>\<tau> on ms implies b \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk> a time-delayed by \<delta>\<tau> on ms implies b \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  from assms(2) have "\<forall>n. hamlet ((Rep_run sub) n a)
                          \<longrightarrow> (\<exists>m \<ge> n. hamlet ((Rep_run sub) m b)
                                    \<and> time ((Rep_run sub) m ms) =  time ((Rep_run sub) n ms) + \<delta>\<tau>)"
    using TESL_interpretation_atomic.simps(6)[of "a" "\<delta>\<tau>" "ms" "b"] by simp
  hence **:"\<forall>n\<^sub>0. hamlet ((Rep_run r) (f n\<^sub>0) a)
                  \<longrightarrow> (\<exists>m\<^sub>0 \<ge> n\<^sub>0. hamlet ((Rep_run r) (f m\<^sub>0) b)
                             \<and>  time ((Rep_run r) (f m\<^sub>0) ms) = time ((Rep_run r) (f n\<^sub>0) ms) + \<delta>\<tau>)"
    using * by (simp add: dilating_def)
  hence "\<forall>n. hamlet ((Rep_run r) n a)
                  \<longrightarrow> (\<exists>m \<ge> n. hamlet ((Rep_run r) m b)
                             \<and> time ((Rep_run r) m ms) = time ((Rep_run r) n ms) + \<delta>\<tau>)"
  proof -
    { fix n assume assm:"hamlet ((Rep_run r) n a)"
      from ticks_image_sub[OF * assm] obtain n\<^sub>0 where nfn0:"n = f n\<^sub>0" by blast
      with ** assm have
        "(\<exists>m\<^sub>0 \<ge> n\<^sub>0. hamlet ((Rep_run r) (f m\<^sub>0) b)
               \<and>  time ((Rep_run r) (f m\<^sub>0) ms) = time ((Rep_run r) (f n\<^sub>0) ms) + \<delta>\<tau>)" by blast
      hence "(\<exists>m \<ge> n. hamlet ((Rep_run r) m b)
               \<and>  time ((Rep_run r) m ms) = time ((Rep_run r) n ms) + \<delta>\<tau>)"
        using * nfn0 dilating_def dilating_fun_def by (metis strict_mono_less_eq)
    } thus ?thesis by simp
  qed
  thus ?thesis by simp
qed

text {*
  Time relations are preserved by contraction
*}
lemma tagrel_sub_inv:
  assumes "sub \<lless> r"
      and "r \<in> \<lbrakk> time-relation \<lfloor>c\<^sub>1, c\<^sub>2\<rfloor> \<in> R \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "sub \<in> \<lbrakk> time-relation \<lfloor>c\<^sub>1, c\<^sub>2\<rfloor> \<in> R \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where df:"dilating f sub r" by blast
  moreover from assms(2) TESL_interpretation_atomic.simps(3) have
    "r \<in> {\<rho>. \<forall>n. R (time ((Rep_run \<rho>) n c\<^sub>1), time ((Rep_run \<rho>) n c\<^sub>2))}" by blast
  hence "\<forall>n. R (time ((Rep_run r) n c\<^sub>1), time ((Rep_run r) n c\<^sub>2))" by simp
  hence "\<forall>n. (\<exists>n\<^sub>0. f n\<^sub>0 = n) \<longrightarrow> R (time ((Rep_run r) n c\<^sub>1), time ((Rep_run r) n c\<^sub>2))" by simp
  hence "\<forall>n\<^sub>0. R (time ((Rep_run r) (f n\<^sub>0) c\<^sub>1), time ((Rep_run r) (f n\<^sub>0) c\<^sub>2))" by blast
  moreover from dilating_def df have
    "\<forall>n c. time ((Rep_run sub) n c) = time ((Rep_run r) (f n) c)" by blast
  ultimately have "\<forall>n\<^sub>0. R (time ((Rep_run sub) n\<^sub>0 c\<^sub>1), time ((Rep_run sub) n\<^sub>0 c\<^sub>2))" by auto
  thus ?thesis by simp
qed

text {*
  A time relation is preserved through dilation of a run.
*}
lemma tagrel_sub':
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk> time-relation \<lfloor>c\<^sub>1,c\<^sub>2\<rfloor> \<in> R \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "R (time ((Rep_run r) n c\<^sub>1), time ((Rep_run r) n c\<^sub>2))"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  moreover from assms(2) TESL_interpretation_atomic.simps(3) have
    "sub \<in> {r. \<forall>n. R (time ((Rep_run r) n c\<^sub>1), time ((Rep_run r) n c\<^sub>2))}" by blast
  hence 1:"\<forall>n. R (time ((Rep_run sub) n c\<^sub>1), time ((Rep_run sub) n c\<^sub>2))" by simp
  show ?thesis
  proof (induction n)
    case 0
    then show ?case
      by (metis (no_types, lifting) "1" calculation dilating_def dilating_fun_def)
  next
    case (Suc n)
    then show ?case
    proof (cases "\<nexists>n\<^sub>0. f n\<^sub>0 = Suc n")
      case True
        thus ?thesis by (metis Suc.IH calculation dilating_def dilating_fun_def)
    next
      case False
      from this obtain n\<^sub>0 where n\<^sub>0prop:"f n\<^sub>0 = Suc n" by blast
      from 1 have "R (time ((Rep_run sub) n\<^sub>0 c\<^sub>1), time ((Rep_run sub) n\<^sub>0 c\<^sub>2))" by simp
      moreover from n\<^sub>0prop * have "time ((Rep_run sub) n\<^sub>0 c\<^sub>1) = time ((Rep_run r) (Suc n) c\<^sub>1)"
        by (simp add: dilating_def)
      moreover from n\<^sub>0prop * have "time ((Rep_run sub) n\<^sub>0 c\<^sub>2) = time ((Rep_run r) (Suc n) c\<^sub>2)"
        by (simp add: dilating_def)
      ultimately show ?thesis by simp
    qed
  qed
qed

corollary tagrel_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk> time-relation \<lfloor>c\<^sub>1,c\<^sub>2\<rfloor> \<in> R \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk> time-relation \<lfloor>c\<^sub>1,c\<^sub>2\<rfloor> \<in> R \<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
using tagrel_sub'[OF assms] unfolding TESL_interpretation_atomic.simps(3) by simp

end

(*
(* Redo all the lemmas for strictly precedes? APITA! *)
(* Not proven *)
theorem strictly_precedes_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  from assms(2) have
    "\<forall>n. (run_tick_count sub c\<^sub>2 n) \<le> (run_tick_count_strictly sub c\<^sub>1 n)" by simp
  hence "\<forall>n. (tick_count sub c\<^sub>2 n) \<le> (tick_count_strict sub c\<^sub>1 n)"
    using tick_count_is_fun tick_count_strict_is_fun by metis
  hence "\<forall>n. tick_count r c\<^sub>2 (f n) \<le> tick_count_strict r c\<^sub>1 (f n)"
    using tick_count_sub[OF *, of "c\<^sub>2"] tick_count_strict_sub[OF *, of "c\<^sub>1"] by simp
  hence "\<forall>n. (tick_count r c\<^sub>2 n) \<le> (tick_count_strict r c\<^sub>1 n)"
    sorry
  hence "r \<in> {\<rho>. \<forall>n. (tick_count \<rho> c\<^sub>2 n) \<le> (tick_count_strict \<rho> c\<^sub>1 n)}" by simp
  hence "r \<in> {\<rho>. \<forall>n. (run_tick_count \<rho> c\<^sub>2 n) \<le> (run_tick_count_strictly \<rho> c\<^sub>1 n)}"
    using tick_count_is_fun[of _ "c\<^sub>2"] tick_count_strict_is_fun[of _ "c\<^sub>1"] sorry
  thus ?thesis using TESL_interpretation_atomic.simps(9)[symmetric, of "c\<^sub>2" "c\<^sub>1"] 
    oops

(* Not proven *)
theorem strictly_precedes_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  from assms(2) strictly_precedes_alt_def1 have
    "\<forall>n::nat. (run_tick_count_strictly sub c\<^sub>2 (Suc n)) \<le> (run_tick_count_strictly sub c\<^sub>1 n)" by simp
  hence "\<forall>n::nat. (run_tick_count_strictly r c\<^sub>2 (f (Suc n))) \<le> (run_tick_count_strictly r c\<^sub>1 (f n))"
    using tick_count_strict_sub[OF *] tick_count_strict_is_fun by metis
  hence "\<forall>n::nat. (run_tick_count_strictly r c\<^sub>2 (Suc n)) \<le> (run_tick_count_strictly r c\<^sub>1 n)" 
oops

(* Not proven *)
theorem strictly_precedes_sub:
  assumes "sub \<lless> r"
      and "sub \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
    shows "r \<in> \<lbrakk>c\<^sub>1 strictly precedes c\<^sub>2\<rbrakk>\<^sub>T\<^sub>E\<^sub>S\<^sub>L"
proof -
  from assms(1) is_subrun_def obtain f where *:"dilating f sub r" by blast
  from assms(2) TESL_interpretation_atomic.simps(8) strictly_precedes_alt_def2 have
    0:"(\<not>hamlet ((Rep_run sub) 0 c\<^sub>2)) \<and> (\<forall>n::nat. (run_tick_count sub c\<^sub>2 (Suc n)) \<le> (run_tick_count sub c\<^sub>1 n))" by blast
  hence 1:"(\<not>hamlet ((Rep_run r) (f 0) c\<^sub>2)) \<and> (\<forall>n::nat. (run_tick_count r c\<^sub>2 (f (Suc n))) \<le> (run_tick_count r c\<^sub>1 (f n)))"
    using * dilating_def run_tick_count_sub[OF *] by metis
  have "(\<not>hamlet ((Rep_run r) 0 c\<^sub>2)) \<and> (\<forall>n::nat. (run_tick_count r c\<^sub>2 (Suc n)) \<le> (run_tick_count r c\<^sub>1 n))"
  proof
    from 1 "*" empty_dilated_prefix show "\<not>hamlet ((Rep_run r) 0 c\<^sub>2)" by fastforce
    from 1 have "\<forall>n::nat. (run_tick_count r c\<^sub>2 (f (Suc n))) \<le> (run_tick_count r c\<^sub>1 (f n))" by simp
    from 0 show "\<forall>n::nat. (run_tick_count r c\<^sub>2 (Suc n)) \<le> (run_tick_count r c\<^sub>1 n)"
      using dil_tick_count_suc[OF assms(1)] by simp
  qed
  thus ?thesis using TESL_interpretation_atomic.simps(8) strictly_precedes_alt_def2 by blast
qed
*)