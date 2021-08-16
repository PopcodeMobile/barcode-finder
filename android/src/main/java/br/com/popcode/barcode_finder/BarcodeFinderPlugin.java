package br.com.popcode.barcode_finder;

import android.content.Context;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class BarcodeFinderPlugin implements FlutterPlugin {
    private MethodChannel channel;

    private void registerPlugin(Context context, BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "popcode.com.br/barcode_finder");
        setMethodCallHandler(context);
    }

    private void setMethodCallHandler(Context context) {
        MethodCallHandlerImpl methodCallHandler = new MethodCallHandlerImpl(context);
        channel.setMethodCallHandler(methodCallHandler);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        registerPlugin(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
