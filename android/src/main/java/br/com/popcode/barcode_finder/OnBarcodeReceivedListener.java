package br.com.popcode.barcode_finder;

public interface OnBarcodeReceivedListener {
    void onBarcodeFound(String code);

    void onBarcodeNotFound();

    void onOutOfMemory();
}
