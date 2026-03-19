package br.com.popcode.barcode_finder;

import android.annotation.SuppressLint;
import android.content.ContentResolver;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Paint;
import android.graphics.pdf.PdfRenderer;
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
    private final String barcodeFormat;

    ReadBarcodeFromFile(OnBarcodeReceivedListener listener,
                        Context context,
                        Uri filePath,
                        EntryType entryType,
                        String barcodeFormat
    ) {
        this.listener = listener;
        this.context = context;
        this.filePath = filePath;
        this.entryType = entryType;
        this.barcodeFormat = barcodeFormat;
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
                    bitmap = generateImageFromPdf(filePath, tryNumber);
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

    private Bitmap generateImageFromPdf(Uri assetFileName, int tryNumber) {
        try {
            ContentResolver contentResolver = context.getApplicationContext().getContentResolver();
            ParcelFileDescriptor parcelFileDescriptor = contentResolver.openFileDescriptor(assetFileName, "r", null);
            PdfRenderer renderer = new PdfRenderer(parcelFileDescriptor);
            PdfRenderer.Page page = renderer.openPage(0);
            int width = page.getWidth() * tryNumber;
            int height = page.getHeight() * tryNumber;
            Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            page.render(bmp, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY);
            page.close();
            renderer.close();
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
                BarcodeScannerOptions options =
                        new BarcodeScannerOptions.Builder()
                                .setBarcodeFormats(BarcodeType.findType(barcodeFormat).code).build();
                BarcodeScanner scanner = BarcodeScanning.getClient(options);
                Bitmap bmp = toGrayscale(bMap);
                InputImage image = InputImage.fromBitmap(bmp, 0);
                Task<List<Barcode>> result =  scanner.process(image)
                        .addOnSuccessListener(barcodes -> {
                            if (!barcodes.isEmpty()) {
                                for (Barcode b : barcodes) {
                                    Log.d("BarcodeTest", "Barcode: " + b.getRawValue());
                                }
                            } else {
                                Log.d("BarcodeTest", "Barcode not found");
                            }
                        })
                        .addOnFailureListener(e -> Log.e("BarcodeTest",
                                "Error decoding barcode", e));
                while (!result.isComplete()){
                    Log.d("BarcodeTest", "Processing image...");
                }
                List<Barcode> barcodes = result.getResult();
                if (!barcodes.isEmpty() && (existBarcodeType(barcodes.get(0).getFormat()))){
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

    private boolean existBarcodeType(int format){
        BarcodeType barcodeType = BarcodeType.findType(barcodeFormat);
            if (barcodeType != null && barcodeType.code == format) {
                Log.d("BarcodeTest", "Barcode type is: "+barcodeType.name());
                return true;
            }
        Log.d("BarcodeTest", "Barcode type not found on list");
        return false;
    }

    private Bitmap toGrayscale(Bitmap bmpOriginal)
    {
        int width, height;
        height = bmpOriginal.getHeight();
        width = bmpOriginal.getWidth();
        Bitmap bmpGrayscale = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas c = new Canvas(bmpGrayscale);
        Paint paint = new Paint();
        ColorMatrix cm = new ColorMatrix();
        cm.setSaturation(0);
        cm.setYUV2RGB();
        ColorMatrixColorFilter f = new ColorMatrixColorFilter(cm);
        paint.setColorFilter(f);
        c.drawBitmap(bmpOriginal, 0, 0, paint);
        return bmpGrayscale;
    }
}