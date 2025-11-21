# UTS Mobile Programming 2

**Nama:** Arya Fauzan
**NIM:** 23552011321
**Kelas:** RP 23 CNS B

---

## Bagian A - Jawaban Teori

**1. Jelaskan bagaimana state management dengan Cubit dapat membantu dalam pengelolaan transaksi yang memiliki logika diskon dinamis.**
> **Jawaban:**
> Cubit membantu memisahkan **logika bisnis** (perhitungan harga, diskon, kuantitas) dari **UI (tampilan)**.
> * **Pemisahan Logic:** Logika diskon dihitung di dalam Cubit (`_calculateTotal`), bukan di halaman UI, sehingga kode lebih rapi.
> * **Reactivity:** Ketika user menambah barang atau kuantitas berubah, Cubit otomatis memancarkan state baru. UI (`BlocBuilder`) akan langsung merender ulang total harga tanpa perlu `setState` manual.
> * **Konsistensi:** Data keranjang tersimpan di memori Cubit, sehingga data tetap sinkron antar halaman.

**2. Apa perbedaan antara diskon per item dan diskon total transaksi? Berikan contoh penerapannya.**
> **Jawaban:**
> * **Diskon Per Item:** Potongan harga yang melekat pada produk tertentu saja dan dihitung **sebelum** masuk total.
>     * *Contoh:* "Kopi Susu" diskon 20%. Harga 15.000 menjadi 12.000 saat masuk keranjang.
> * **Diskon Total Transaksi:** Potongan harga yang diterapkan pada jumlah akhir seluruh belanjaan berdasarkan syarat tertentu.
>     * *Contoh:* "Diskon 10% untuk total belanja di atas Rp100.000". Jika subtotal Rp150.000, maka dipotong Rp15.000 di akhir pembayaran.

**3. Jelaskan manfaat penggunaan widget Stack pada tampilan kategori menu di aplikasi Flutter.**
> **Jawaban:**
> Widget `Stack` memungkinkan penumpukan widget di atas widget lain (sumbu Z). Manfaatnya di aplikasi ini:
> * **Desain Estetik:** Memungkinkan pembuatan kartu kategori dengan background gradasi yang ditumpuk dengan ikon besar transparan sebagai dekorasi artistik.
> * **Fleksibilitas Posisi:** Memudahkan penempatan teks judul dan ikon kecil di posisi tertentu (misal: pojok kiri) tanpa terganggu oleh elemen dekorasi background.

---

## Bagian B & C - Fitur Aplikasi

Aplikasi ini telah memiliki fitur:
1.  **Daftar Menu** dengan kategori (Makanan, Minuman, Snack).
2.  **State Management** menggunakan Cubit.
3.  **Diskon Per Item** (Coret harga).
4.  **Keranjang Belanja** dengan fitur tambah/kurang kuantitas.
5.  **Bonus:** Diskon otomatis 10% jika belanja > Rp100.000.
