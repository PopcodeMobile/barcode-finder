package br.com.popcode.barcode_finder;

public enum BarcodeType {
    ALL(0),
    CODE128(1),
    CODE39(2),
    CODE93(4),
    CODABAR(8),
    DATAMATRIX(16),
    EAN13(32),
    EAN8(64),
    ITF(128),
    QRCODE(256),
    UPCA(512),
    UPCE(1024),
    PDF417(2048),
    AZTEC(4096);

    public final int code;

    BarcodeType(int code) {
        this.code = code;
    }

    public static BarcodeType findType(String format){
        for (BarcodeType e : BarcodeType.values()) {
            if (e.name().equals(format)) {
                return e;
            }
        }
        return null;
    }
}
