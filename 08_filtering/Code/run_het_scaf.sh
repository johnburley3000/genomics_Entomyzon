#!/bin/bash
# J Burley 
# Date: July 5 2017
# Purpose: Run VCFtools --het per scaf, in a loop, then cat the results in one table

#SBATCH -p general
#SBATCH -n 1
#SBATCH -N 1
#SBATCH --mem 20000
#SBATCH -t 10:00:00
#SBATCH -J het_scaf
#SBATCH -o Logs/het_scaf_%j.out
#SBATCH -e Logs/het_scaf_%j.err

module load vcftools/0.1.14-fasrc01

GROUP=E_cyan_snps_rm_autos_filt

for SCAF in  scaffold_0 scaffold_1 scaffold_2 scaffold_3 scaffold_4 scaffold_5 scaffold_7 scaffold_8 scaffold_9 scaffold_10 scaffold_11 scaffold_12 scaffold_13 scaffold_14 scaffold_15 scaffold_16 scaffold_17 scaffold_19 scaffold_20 scaffold_22 scaffold_23 scaffold_24 scaffold_25 scaffold_26 scaffold_27 scaffold_28 scaffold_29 scaffold_30 scaffold_32 scaffold_33 scaffold_34 scaffold_35 scaffold_36 scaffold_37 scaffold_38 scaffold_39 scaffold_40 scaffold_41 scaffold_42 scaffold_43 scaffold_44 scaffold_45 scaffold_46 scaffold_47 scaffold_49 scaffold_50 scaffold_51 scaffold_52 scaffold_53 scaffold_54 scaffold_55 scaffold_56 scaffold_58 scaffold_59 scaffold_60 scaffold_61 scaffold_62 scaffold_63 scaffold_64 scaffold_65 scaffold_66 scaffold_67 scaffold_68 scaffold_69 scaffold_70 scaffold_71 scaffold_72 scaffold_73 scaffold_74 scaffold_75 scaffold_76 scaffold_77 scaffold_78 scaffold_79 scaffold_80 scaffold_81 scaffold_82 scaffold_83 scaffold_84 scaffold_85 scaffold_86 scaffold_87 scaffold_88 scaffold_89 scaffold_90 scaffold_91 scaffold_92 scaffold_93 scaffold_94 scaffold_95 scaffold_96 scaffold_97 scaffold_98 scaffold_99 scaffold_100 scaffold_102 scaffold_104 scaffold_105 scaffold_106 scaffold_107 scaffold_109 scaffold_111 scaffold_112 scaffold_113 scaffold_115 scaffold_116 scaffold_117 scaffold_118 scaffold_119 scaffold_120 scaffold_121 scaffold_122 scaffold_123 scaffold_125 scaffold_126 scaffold_131 scaffold_132 scaffold_133 scaffold_134 scaffold_135 scaffold_137 scaffold_138 scaffold_139 scaffold_140 scaffold_141 scaffold_142 scaffold_143 scaffold_144 scaffold_145 scaffold_146 scaffold_147 scaffold_148 scaffold_150 scaffold_151 scaffold_152 scaffold_154 scaffold_156 scaffold_160 scaffold_161 scaffold_162 scaffold_163 scaffold_166 scaffold_167 scaffold_168 scaffold_169 scaffold_171 scaffold_172 scaffold_176 scaffold_177 scaffold_178 scaffold_180 scaffold_182 scaffold_184 scaffold_185 scaffold_186 scaffold_187 scaffold_188 scaffold_189 scaffold_190 scaffold_191 scaffold_192 scaffold_193 scaffold_194 scaffold_197 scaffold_199 scaffold_200 scaffold_201 scaffold_202 scaffold_203 scaffold_204 scaffold_205 scaffold_206 scaffold_207 scaffold_208 scaffold_209 scaffold_210 scaffold_211 scaffold_212 scaffold_213 scaffold_214 scaffold_215 scaffold_216 scaffold_218 scaffold_219 scaffold_220 scaffold_221 scaffold_222 scaffold_223 scaffold_224 scaffold_225 scaffold_226 scaffold_227 scaffold_228 scaffold_229 scaffold_232 scaffold_233 scaffold_235 scaffold_236 scaffold_237 scaffold_238 scaffold_239 scaffold_240 scaffold_241 scaffold_242 scaffold_243 scaffold_244 scaffold_247 scaffold_248 scaffold_249 scaffold_250 scaffold_251 scaffold_252 scaffold_253 scaffold_254 scaffold_255 scaffold_256 scaffold_257 scaffold_258 scaffold_260 scaffold_267 scaffold_268 scaffold_269 scaffold_270 scaffold_271 scaffold_278 scaffold_279 scaffold_280 scaffold_281 scaffold_282 scaffold_283 scaffold_284 scaffold_285 scaffold_286 scaffold_287 scaffold_288 scaffold_289 scaffold_290 scaffold_291 scaffold_292 scaffold_293 scaffold_294 scaffold_295 scaffold_299 scaffold_300 scaffold_302 scaffold_303 scaffold_304 scaffold_305 scaffold_306 scaffold_307 scaffold_308 scaffold_309 scaffold_310 scaffold_311 scaffold_312 scaffold_313 scaffold_314 scaffold_315 scaffold_316 scaffold_317 scaffold_318 scaffold_319 scaffold_320 scaffold_321 scaffold_322 scaffold_324 scaffold_325 scaffold_326 scaffold_327 scaffold_328 scaffold_330 scaffold_331 scaffold_332 scaffold_334 scaffold_337 scaffold_338 scaffold_343 scaffold_344 scaffold_345 scaffold_346 scaffold_347 scaffold_348 scaffold_349 scaffold_351 scaffold_352 scaffold_353 scaffold_354 scaffold_355 scaffold_356 scaffold_357 scaffold_359 scaffold_361 scaffold_363 scaffold_365 scaffold_367 scaffold_369 scaffold_371 scaffold_373 scaffold_374 scaffold_375 scaffold_376 scaffold_377 scaffold_378 scaffold_380 scaffold_381 scaffold_382 scaffold_383 scaffold_384 scaffold_385 scaffold_386 scaffold_387 scaffold_389 scaffold_391 scaffold_393 scaffold_394 scaffold_395 scaffold_396 scaffold_397 scaffold_398 scaffold_400 scaffold_402 scaffold_403
do
vcftools --vcf Data/${GROUP}.vcf --chr $SCAF --out Results/VCFtools/Het_by_scaf/${GROUP}_${SCAF} --het
sed "s/$/\t$SCAF/g" Results/VCFtools/Het_by_scaf/${GROUP}_${SCAF}.het > Results/VCFtools/Het_by_scaf/${GROUP}_${SCAF}_new.het
done

cat Results/VCFtools/Het_by_scaf/${GROUP}_*_new.het > Results/VCFtools/het_by_scaf.out
