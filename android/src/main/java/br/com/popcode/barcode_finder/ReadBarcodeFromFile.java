package br.com.popcode.barcode_finder;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.ParcelFileDescriptor;
import android.util.Log;

import com.google.android.gms.tasks.Task;
import com.google.mlkit.vision.barcode.BarcodeScanner;
import com.google.mlkit.vision.barcode.BarcodeScannerOptions;
import com.google.mlkit.vision.barcode.BarcodeScanning;
import com.google.mlkit.vision.barcode.common.Barcode;
import com.google.mlkit.vision.common.InputImage;
import com.shockwave.pdfium.PdfDocument;
import com.shockwave.pdfium.PdfiumCore;

import java.util.ArrayList;
import java.util.List;

public class ReadBarcodeFromFile extends AsyncTask<Void, Void, String> {

    private static final int NUMBER_OF_ATTEMPTS = 4;
    private static final double PORCENTAGEM_ESCALA = 0.05;

    @SuppressLint("StaticFieldLeak")
    private final Context context;
    private final Uri filePath;
    private boolean outOfMemoryError = false;
    private final OnBarcodeReceivedListener listener;
    private final EntryType entryType;
    private final ArrayList barcodeFormats;

    ReadBarcodeFromFile(OnBarcodeReceivedListener listener, Context context, Uri filePath, EntryType entryType, ArrayList barcodeFormats) {
        this.listener = listener;
        this.context = context;
        this.filePath = filePath;
        this.entryType = entryType;
        this.barcodeFormats = barcodeFormats;
    }

    @Override
    protected void onPreExecute() {
    }

    private Bitmap resizeImage(Bitmap bitmap, int tryNumber){
        int width = (int) (bitmap.getWidth() * (1-tryNumber * PORCENTAGEM_ESCALA));
        int height = (int) (bitmap.getHeight() * (1-tryNumber * PORCENTAGEM_ESCALA));
        bitmap = Bitmap.createScaledBitmap(bitmap, width,height, false);
        return bitmap;
    }

    @Override
    protected String doInBackground(Void... voids) {
        if (filePath != null) {
            int tryNumber = 1;
            while (tryNumber <= NUMBER_OF_ATTEMPTS && !outOfMemoryError) {
                Bitmap bitmap;
                if (entryType == EntryType.PDF) {
                    bitmap = generateImageFromPdf(filePath, 0, tryNumber);
                } else {
                    bitmap = BitmapFactory.decodeFile(filePath.getPath());
                    bitmap = resizeImage(bitmap, tryNumber);
                }
                if (bitmap != null) {
                    String code = scanImage(bitmap);
                    if (code != null && !code.isEmpty()) {
                        return code;
                    }
                }
                tryNumber++;
            }
        }
        return "";
    }

    @Override
    protected void onPostExecute(String result) {
        if (!outOfMemoryError) {
            if (result != null && !result.isEmpty()) {
                listener.onBarcodeFound(result);
            } else {
                listener.onBarcodeNotFound();
            }
        } else {
            listener.onOutOfMemory();
        }
    }

    private Bitmap generateImageFromPdf(Uri assetFileName, int numeroPagina, int tryNumber) {
        PdfiumCore pdfiumCore = new PdfiumCore(context);
        try {
            ParcelFileDescriptor parcelFileDescriptor;
            ContentResolver contentResolver = context.getApplicationContext().getContentResolver();
            parcelFileDescriptor = contentResolver.openFileDescriptor(assetFileName, "r", null);
            PdfDocument pdfDocument = pdfiumCore.newDocument(parcelFileDescriptor);
            pdfiumCore.openPage(pdfDocument, numeroPagina);
            int width = pdfiumCore.getPageWidthPoint(pdfDocument, numeroPagina) * tryNumber;
            int height = pdfiumCore.getPageHeightPoint(pdfDocument, numeroPagina) * tryNumber;
            Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            pdfiumCore.renderPageBitmap(pdfDocument, bmp, numeroPagina, 0, 0, width, height);
            pdfiumCore.closeDocument(pdfDocument);
            return bmp;
        } catch (OutOfMemoryError e) {
            Log.e("BarcodeTest", "Error Out of memory", e);
            outOfMemoryError = true;
            return null;
        } catch (Exception e) {
            Log.e("Bitmap PDF", e.getMessage());
        }
        return null;
    }

    private String scanImage(Bitmap bMap) {
        try {
            if (!outOfMemoryError) {
                InputImage image = InputImage.fromBitmap(bMap, 0);
                BarcodeScannerOptions options =
                        new BarcodeScannerOptions.Builder()
                                .enableAllPotentialBarcodes() // Optional
                        .build();
                BarcodeScanner scanner = BarcodeScanning.getClient(options);
                Task<List<Barcode>> result =  scanner.process(image)
                        .addOnSuccessListener(barcodes -> {
                            if(!barcodes.isEmpty()){
                                for (Barcode b: barcodes) {
                                    Log.d("BarcodeTest", "Barcode: "+b.getRawValue());
                                }
                            }else{
                                Log.d("BarcodeTest", "Barcode not found");
                            }
                        })
                        .addOnFailureListener(e -> {
                            Log.e("BarcodeTest", "Error Out of memory", e);
                        });
                while (!result.isComplete()){
                    Log.d("BarcodeTest", "Processing image...");
                }
                List<Barcode> barcodes = result.getResult();
                if (!barcodes.isEmpty() && (barcodeFormats.isEmpty() ||
                        barcodeFormats.contains(barcodes.get(0).getFormat()))){
                    return barcodes.get(0).getRawValue();
                }
            }
        } catch (OutOfMemoryError e) {
            Log.e("BarcodeTest", "Error Out of memory", e);
            outOfMemoryError = true;
            return null;
        } catch (Exception e) {
            Log.e("BarcodeTest", "Error decoding barcode", e);
        }
        return "";
    }
}