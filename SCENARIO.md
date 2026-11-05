Senaryo: Fitness Uygulamasında Prompt Sürümlerinin A/B Testi
Problem Bir fitness uygulaması kullanıcılara egzersiz önerileri sunan bir öneri motoru kullanıyor. Motorun açıklama metnini üreten promptun iki sürümü var (v1 ve v2). Ekip, v2'nin egzersiz tamamlama oranını artırıp artırmadığını görmek istiyor.

1- Ana soru v2 promptu, v1'e göre egzersiz tamamlama oranında anlamlı bir fark yaratıyor mu?

2- Hedef kullanıcı Uygulamanın ürün ve veri ekibi (prompt sürümleri arasında karar verecek olanlar).

3- Tablo adayları A- prompt_versions(id, version_name, created_at) B- recommendations(id, prompt_id, exercise_type, generated_at) C- completions(id, recommendation_id, is_completed, duration_min)

4- YZ bileşeni Hangi prompt sürümünün hangi öneriyi ürettiğini kaydeden ve A/B sonucunu izleyen bir yapı (dönem sonunda veritabanında uygulanacak).

5- Veri kaynağı adayları A- Kaggle: "workout", "fitness tracking", "exercise adherence" aramaları B- Hugging Face: "prompt", "A/B" aramaları C- Kriter: anonim, kişisel bilgi içermeyen, açık lisanslı, en az 500 öneri satırı

