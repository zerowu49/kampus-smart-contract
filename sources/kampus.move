module kampus::fungsi_string {
    use std::string::String;

    // Struct untuk menyimpan nama mahasiswa
    public struct Mahasiswa has key {
        id: UID,
        nama: String,
    }

    // Fungsi untuk membuat mahasiswa baru
    public fun buat_mahasiswa(nama: String, context: &mut TxContext): Mahasiswa {
        Mahasiswa {
            id: object::new(context),
            nama,
        }
    }

    // Fungsi untuk mengubah nama
    public fun ubah_nama(mahasiswa: &mut Mahasiswa, nama_baru: String) {
        mahasiswa.nama = nama_baru;
    }

    // Fungsi untuk mendapatkan nama
    public fun get_nama(mahasiswa: &Mahasiswa): String {
        mahasiswa.nama
    }
}

module kampus::fungsi_number {
    // Struct untuk data mahasiswa dengan angka
    public struct DataMahasiswa has key {
        id: UID,
        nim: u32,
        umur: u8,
        total_sks: u64,
    }

    // Fungsi untuk membuat data mahasiswa
    public fun buat_data_mahasiswa(nim: u32, umur: u8, ctx: &mut TxContext): DataMahasiswa {
        DataMahasiswa {
            id: object::new(ctx),
            nim,
            umur,
            total_sks: 0,
        }
    }

    // Fungsi untuk menambah SKS
    public fun tambah_sks(data: &mut DataMahasiswa, sks: u64) {
        data.total_sks = data.total_sks + sks;
    }

    // Fungsi untuk menambah umur
    public fun tambah_umur(data: &mut DataMahasiswa) {
        data.umur = data.umur + 1;
    }
}

module kampus::fungsi_boolean {
    use std::string::String;

    // Struct dengan boolean
    public struct StatusMahasiswa has key {
        id: UID,
        nama: String,
        aktif: bool,
        lulus: bool,
    }

    // Fungsi untuk membuat status mahasiswa
    public fun buat_status(nama: String, ctx: &mut TxContext): StatusMahasiswa {
        StatusMahasiswa {
            id: object::new(ctx),
            nama,
            aktif: true, // Default aktif
            lulus: false, // Default belum lulus
        }
    }

    // Fungsi untuk set lulus
    public fun set_lulus(status: &mut StatusMahasiswa) {
        status.lulus = true;
    }

    // Fungsi untuk nonaktifkan
    public fun nonaktifkan(status: &mut StatusMahasiswa) {
        status.aktif = false;
    }

    // Fungsi untuk cek apakah bisa wisuda
    public fun bisa_wisuda(status: &StatusMahasiswa): bool {
        status.aktif && status.lulus
    }
}

module kampus::data_mahasiswa_lengkap {
    use std::string::String;

    // Struct lengkap mahasiswa
    public struct Mahasiswa has key {
        id: UID,
        nama: String,
        nim: u32,
        jurusan: String,
        umur: u8,
        total_sks: u64,
        aktif: bool,
        lulus: bool,
    }

    // Fungsi untuk membuat mahasiswa baru
    public fun daftar_mahasiswa(
        nama: String,
        nim: u32,
        jurusan: String,
        umur: u8,
        ctx: &mut TxContext,
    ) {
        let mahasiswa = Mahasiswa {
            id: object::new(ctx),
            nama,
            nim,
            jurusan,
            umur,
            total_sks: 0,
            aktif: true,
            lulus: false,
        };
        transfer::transfer(mahasiswa, tx_context::sender(ctx));
    }

    // Fungsi untuk ambil mata kuliah (tambah SKS)
    public fun ambil_mata_kuliah(mhs: &mut Mahasiswa, sks: u64) {
        mhs.total_sks = mhs.total_sks + sks;
    }

    // Fungsi untuk lulus
    public fun set_lulus(mhs: &mut Mahasiswa) {
        // Syarat lulus: minimal 144 SKS
        if (mhs.total_sks >= 144) {
            mhs.lulus = true;
        }
    }

    // Fungsi untuk get info mahasiswa
    public fun get_info(mhs: &Mahasiswa): (String, u32, u64, bool) {
        (mhs.nama, mhs.nim, mhs.total_sks, mhs.lulus)
    }
}

module kampus::fungsi_vector {
    use std::string::String;

    // Struct untuk menyimpan daftar mahasiswa
    public struct DaftarMahasiswa has key {
        id: UID,
        nama_mahasiswa: vector<String>,
        nim_mahasiswa: vector<u32>,
    }

    // Fungsi untuk membuat daftar kosong
    public fun buat_daftar_kosong(ctx: &mut TxContext): DaftarMahasiswa {
        DaftarMahasiswa {
            id: object::new(ctx),
            nama_mahasiswa: vector::empty<String>(),
            nim_mahasiswa: vector::empty<u32>(),
        }
    }

    // Fungsi untuk tambah mahasiswa ke daftar
    public fun tambah_mahasiswa(daftar: &mut DaftarMahasiswa, nama: String, nim: u32) {
        vector::push_back(&mut daftar.nama_mahasiswa, nama);
        vector::push_back(&mut daftar.nim_mahasiswa, nim);
    }

    // Fungsi untuk menghitung jumlah mahasiswa
    public fun jumlah_mahasiswa(daftar: &DaftarMahasiswa): u64 {
        vector::length(&daftar.nama_mahasiswa)
    }

    // Fungsi untuk mendapatkan mahasiswa berdasarkan index
    public fun get_mahasiswa_ke(daftar: &DaftarMahasiswa, index: u64): (String, u32) {
        let nama = *vector::borrow(&daftar.nama_mahasiswa, index);
        let nim = *vector::borrow(&daftar.nim_mahasiswa, index);
        (nama, nim)
    }

    // Fungsi untuk cek apakah daftar kosong
    public fun apakah_kosong(daftar: &DaftarMahasiswa): bool {
        vector::is_empty(&daftar.nama_mahasiswa)
    }
}

module kampus::owned_objects {
    use std::string::String;

    // Struct mahasiswa yang dimiliki oleh address tertentu
    public struct KartuMahasiswa has key, store {
        id: UID,
        nama: String,
        nim: u32,
        jurusan: String,
        tahun_masuk: u16,
    }

    // Fungsi untuk membuat kartu mahasiswa (owned object)
    public fun daftar_mahasiswa(
        nama: String,
        nim: u32,
        jurusan: String,
        tahun_masuk: u16,
        ctx: &mut TxContext,
    ) {
        let kartu = KartuMahasiswa {
            id: object::new(ctx),
            nama,
            nim,
            jurusan,
            tahun_masuk,
        };

        // Transfer ke sender (mahasiswa yang mendaftar)
        transfer::transfer(kartu, tx_context::sender(ctx));
    }

    // Mahasiswa bisa update data sendiri
    public fun update_nama(kartu: &mut KartuMahasiswa, nama_baru: String) {
        kartu.nama = nama_baru;
    }

    // Fungsi untuk transfer kartu ke orang lain
    public fun transfer_kartu(kartu: KartuMahasiswa, penerima: address) {
        transfer::transfer(kartu, penerima);
    }
}

module kampus::shared_objects {
    use std::string::String;

    // Struct untuk registrasi kampus (shared object)
    public struct RegistrasiKampus has key {
        id: UID,
        nama_kampus: String,
        total_mahasiswa: u64,
        daftar_nim: vector<u32>,
        admin: address,
    }

    // Fungsi untuk membuat registrasi kampus (shared)
    public fun buat_registrasi_kampus(nama_kampus: String, ctx: &mut TxContext) {
        let registrasi = RegistrasiKampus {
            id: object::new(ctx),
            nama_kampus,
            total_mahasiswa: 0,
            daftar_nim: vector::empty<u32>(),
            admin: tx_context::sender(ctx),
        };

        // Share object agar semua orang bisa akses
        transfer::share_object(registrasi);
    }

    // Siapa saja bisa lihat jumlah mahasiswa
    public fun get_total_mahasiswa(registrasi: &RegistrasiKampus): u64 {
        registrasi.total_mahasiswa
    }

    // Hanya admin yang bisa tambah mahasiswa
    public fun tambah_mahasiswa_ke_registrasi(
        registrasi: &mut RegistrasiKampus,
        nim: u32,
        ctx: &TxContext,
    ) {
        // Cek apakah yang memanggil adalah admin
        assert!(registrasi.admin == tx_context::sender(ctx), 0);

        // Tambah mahasiswa
        registrasi.total_mahasiswa = registrasi.total_mahasiswa + 1;
        vector::push_back(&mut registrasi.daftar_nim, nim);
    }
}

module kampus::capabilities_pattern {
    use std::string::String;

    // Admin capability - hanya admin yang punya
    public struct AdminCap has key, store {
        id: UID,
    }

    // Dosen capability - hanya dosen yang punya
    public struct DosenCap has key, store {
        id: UID,
        mata_kuliah: String,
    }

    // Struct untuk sistem nilai
    public struct SistemNilai has key {
        id: UID,
        total_mahasiswa: u64,
    }

    // Struct untuk nilai mahasiswa
    public struct NilaiMahasiswa has key, store {
        id: UID,
        nim: u32,
        mata_kuliah: String,
        nilai: u8,
        dosen_pemberi: address,
    }

    // Init function - jalan sekali saat deploy
    fun init(ctx: &mut TxContext) {
        // Buat admin capability
        let admin_cap = AdminCap {
            id: object::new(ctx),
        };

        // Buat sistem nilai
        let sistem = SistemNilai {
            id: object::new(ctx),
            total_mahasiswa: 0,
        };

        // Transfer admin cap ke deployer
        transfer::transfer(admin_cap, tx_context::sender(ctx));

        // Share sistem nilai
        transfer::share_object(sistem);
    }

    // Hanya admin yang bisa buat dosen capability
    public fun buat_dosen_cap(
        _: &AdminCap, // Admin capability sebagai "kunci"
        mata_kuliah: String,
        dosen_address: address,
        ctx: &mut TxContext,
    ) {
        let dosen_cap = DosenCap {
            id: object::new(ctx),
            mata_kuliah,
        };

        transfer::transfer(dosen_cap, dosen_address);
    }

    // Hanya dosen yang bisa kasih nilai
    public fun beri_nilai(
        dosen_cap: &DosenCap,
        sistem: &mut SistemNilai,
        nim: u32,
        nilai: u8,
        mahasiswa_address: address,
        ctx: &mut TxContext,
    ) {
        // Validasi nilai
        assert!(nilai <= 100, 1);

        let nilai_obj = NilaiMahasiswa {
            id: object::new(ctx),
            nim,
            mata_kuliah: dosen_cap.mata_kuliah,
            nilai,
            dosen_pemberi: tx_context::sender(ctx),
        };

        // Update sistem
        sistem.total_mahasiswa = sistem.total_mahasiswa + 1;

        // Transfer ke mahasiswa
        transfer::transfer(nilai_obj, mahasiswa_address);
    }
}

module kampus::fungsi_lengkap {
    use std::string::{Self, String};

    // Error constants
    const ENIM_INVALID: u64 = 0;
    const ENILAI_INVALID: u64 = 1;
    const ESKS_INVALID: u64 = 2;
    const ENOT_AUTHORIZED: u64 = 3;

    public struct MahasiswaProfile has key {
        id: UID,
        nama: String,
        nim: u32,
        total_sks: u64,
        nilai_list: vector<u8>,
        owner: address,
    }

    // Fungsi dengan validasi lengkap
    public fun buat_profile(nama: String, nim: u32, ctx: &mut TxContext) {
        // Validasi NIM (8 digit, dimulai 20)
        assert!(nim >= 20000000 && nim <= 29999999, ENIM_INVALID);

        // Validasi nama tidak kosong
        assert!(string::length(&nama) > 0, 100);

        let profile = MahasiswaProfile {
            id: object::new(ctx),
            nama,
            nim,
            total_sks: 0,
            nilai_list: vector::empty<u8>(),
            owner: tx_context::sender(ctx),
        };

        transfer::transfer(profile, tx_context::sender(ctx));
    }

    // Fungsi dengan authorization check
    public fun tambah_nilai(profile: &mut MahasiswaProfile, nilai: u8, sks: u64, ctx: &TxContext) {
        // Cek ownership
        assert!(profile.owner == tx_context::sender(ctx), ENOT_AUTHORIZED);

        // Validasi nilai (0-100)
        assert!(nilai <= 100, ENILAI_INVALID);

        // Validasi SKS (1-6)
        assert!(sks >= 1 && sks <= 6, ESKS_INVALID);

        // Update data
        vector::push_back(&mut profile.nilai_list, nilai);
        profile.total_sks = profile.total_sks + sks;
    }

    // Fungsi dengan multiple return values dan control flow
    public fun analisis_performa(profile: &MahasiswaProfile): (u64, bool, String) {
        let jumlah_mk = vector::length(&profile.nilai_list);

        // Return early jika belum ada nilai
        if (jumlah_mk == 0) {
            return (0, false, string::utf8(b"Belum ada nilai"))
        };

        // Hitung rata-rata nilai
        let mut total_nilai = 0u64;
        let mut i = 0;

        while (i < jumlah_mk) {
            let nilai = *vector::borrow(&profile.nilai_list, i);
            total_nilai = total_nilai + (nilai as u64);
            i = i + 1;
        };

        let rata_rata = total_nilai / jumlah_mk;

        // Tentukan status dan pesan
        let (bisa_lulus, pesan) = if (rata_rata >= 60 && profile.total_sks >= 144) {
            (true, string::utf8(b"Bisa lulus"))
        } else if (rata_rata < 60) {
            (false, string::utf8(b"Nilai kurang"))
        } else {
            (false, string::utf8(b"SKS kurang"))
        };

        (rata_rata, bisa_lulus, pesan)
    }

    // Fungsi untuk cari nilai tertinggi
    public fun cari_nilai_tertinggi(profile: &MahasiswaProfile): u8 {
        let nilai_list = &profile.nilai_list;
        let len = vector::length(nilai_list);

        assert!(len > 0, 200); // Harus ada nilai

        let mut max_nilai = *vector::borrow(nilai_list, 0);
        let mut i = 1;

        while (i < len) {
            let nilai = *vector::borrow(nilai_list, i);
            if (nilai > max_nilai) {
                max_nilai = nilai;
            };
            i = i + 1;
        };

        max_nilai
    }
}
